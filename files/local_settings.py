# Setting Overrides
# See readthedocs/settings/*.py for settings that need to be modified
import os

# If you set $RTD_PRODUCTION_DOMAIN, do not edit the below. Otherwise, replace
# localhost with the root domain where this RTD installation will be running
PRODUCTION_DOMAIN = os.getenv('RTD_PRODUCTION_DOMAIN', 'localhost')

# Leave this as false unless you have wildcard DNS setup for quick URLs
USE_SUBDOMAIN = False

# Set the send from email address
DEFAULT_FROM_EMAIL = "no-reply@" + PRODUCTION_DOMAIN

# If you set your timezone using $TZ, do not edit the below. Otherwise, replace
# America/Chicago with your local timezone (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
TIME_ZONE = os.getenv('TZ', 'America/Chicago')

# Set the Slumber API host
SLUMBER_API_HOST = os.getenv('RTD_SLUMBER_API_HOST', "http://" + PRODUCTION_DOMAIN)

# TODO Allow specification of SMTP settings
# Mail is sent using the SMTP host and port specified in the EMAIL_HOST and
# EMAIL_PORT settings. The EMAIL_HOST_USER and EMAIL_HOST_PASSWORD settings, if
# set, are used to authenticate to the SMTP server, and the EMAIL_USE_TLS and
# EMAIL_USE_SSL settings control whether a secure connection is used.

# Turn off email verification
ACCOUNT_EMAIL_VERIFICATION = 'none'

# Enable private Git doc repositories
ALLOW_PRIVATE_REPOS = True
