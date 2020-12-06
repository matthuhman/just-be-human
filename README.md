## CURRENT DEPLOYMENT NOTES
* deployed to EC2 t2.micro instance with postgres RDS db
  * Ruby 2.6.2
  * Rails 6.0.2.1
  * rvm used for install
  * nginx and passenger
    * to start and stop, use `start-nginx` and `kill-nginx` commands as ec2-user
    * nginx is installed at `/opt/nginx` and passenger is in $PATH
  * important macros:
    * run `assume-jbh-user` command as ec2-user
    * run `redeploy` to redeploy the server from `detrashers-master` branch
    * run `less ~/.zshrc` for important commands and creds
    * run `/etc/certbot-auto --debug -v --server https://acme-v02.api.letsencrypt.org/directory certonly -d detrashers.org` to regen SSL certs
  * ClamAV is installed as an antivirus
    * https://www.clamav.net/documents/installing-clamav for installation instructions
    * 20201205 - I'm not sure I ever got this running


### Rework Goals
  * 20201205
    * build out `Cleanup` object to track # of cleanups done and litter collected
    * actually write some tests once you figure out what the new framework needs to look like


### Useful Links/Future Reading
  * Links
    * Certbot reminder: https://medium.com/@mohan08p/install-and-renew-lets-encrypt-ssl-on-amazon-ami-6d3e0a61693
  * Future Reading
    * How to build a Rails app in 2020 (shoulda read this, huh?) https://blog.echobind.com/optimal-ruby-on-rails-setup-for-2020-db8ea2b2c798
    * Migration from asset pipeline to webpacker https://makandracards.com/makandra/69135-migration-from-the-asset-pipeline-to-webpacker






### Ignore this stuff - I stole this from a rails dev's list of "most used gems"
### and am just using it for easy reference/a reminder to look into the rest of these in the future


Security audit tools:
https://github.com/hardhatdigital/rails-security-audit


I've definitely reduced the amount of gems I use compared to last year.

Base rails

dotenv-rails
puma
webpacker
turbolinks
Users

devise
omniauth
pundit
valid_email2
ActiveStorage

aws-sdk-s3
vips (Instead of the default image_processing gem)
ActiveJob

sidekiq
sidekiq-cron
Logging and exception tracking

lograge
sentry-raven
Making SEO easier

meta-tags
friendly_id
Encouraging I18n usage.

http_accept_language
Cleaner views

draper
simple_form
premailer-rails
For Development

powder
puma-dev - Not really a gem, but I love using it to turn on my rails projects.
puma-ngrok-tunnel
rubocop
rack-mini-profiler
For Testing

rspec-rails
factory_bot_rails
faker
webmock
simplecov
pig-ci-rails
formulaic
Admin tools

ActiveAdmin




