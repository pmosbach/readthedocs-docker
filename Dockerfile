FROM python:2

# Prep the environment
RUN apt-get update && apt-get -y install \
  texlive-latex-recommended \
  texlive-fonts-recommended \
  texlive-latex-extra \
  doxygen \
  dvipng \
  graphviz \
  nginx \
  nano

# Install readthedocs (bits as of Dec 15 2015)
RUN mkdir /www
WORKDIR /www

COPY ./files/readthedocs.org-master.tar.gz ./readthedocs.org-master.tar.gz
RUN tar -zxvf readthedocs.org-master.tar.gz && \
    rm readthedocs.org-master.tar.gz && \
    mv ./readthedocs.org-master ./readthedocs.org

WORKDIR /www/readthedocs.org

# Install the required Python packages
RUN pip install -r requirements.txt

# Install a higher version of requests to fix an SSL issue
RUN pip install requests==2.6.0

# Override the default settings
COPY ./files/local_settings.py ./readthedocs/settings/local_settings.py
COPY ./files/recommonmark.patch ./recommonmark.patch
COPY ./files/mkdocs.patch ./mkdocs.patch

# Patch python_environments.py to use newer recommonmark and remove hard coded URL
RUN patch ./readthedocs/doc_builder/python_environments.py < ./recommonmark.patch && \
    patch ./readthedocs/doc_builder/backends/mkdocs.py < ./mkdocs.patch

# Deploy the database
RUN python ./manage.py migrate

# Create a super user
RUN echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python ./manage.py shell

# Load test data and copy static files
RUN python ./manage.py loaddata test_data && \
    python ./manage.py collectstatic --noinput

# Install gunicorn web server
RUN pip install gunicorn && \
    pip install setproctitle

# Set up the gunicorn startup script
COPY ./files/gunicorn_start.sh ./gunicorn_start.sh
RUN chmod u+x ./gunicorn_start.sh

# Install supervisord
RUN pip install supervisor
COPY files/supervisord.conf /etc/supervisord.conf

VOLUME /www/readthedocs.org

ENV RTD_PRODUCTION_DOMAIN 'localhost'

# Set up nginx
COPY ./files/readthedocs.nginx.conf /etc/nginx/sites-available/readthedocs
RUN ln -s /etc/nginx/sites-available/readthedocs /etc/nginx/sites-enabled/readthedocs && \
    rm /etc/nginx/sites-enabled/default

# Clean Up Apt

RUN apt-get autoremove -y

EXPOSE 80

CMD ["supervisord"]
