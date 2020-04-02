# README

Ruby 2.6.2

Rails 5.2

# CURRENT DEPLOYMENT NOTES
* deployed to EC2 t2.micro instance with postgres RDS db
  * Ruby 2.6.2
  * Rails 6.0.2.1
  * rvm used for install
  * nginx and passenger
    * to start and stop, use `start-nginx` and `kill-nginx` commands as ec2-user
    * nginx is installed at `/opt/nginx` and passenger is in $PATH
  * to redeploy platform:
    * run `assume-jbh-user` command as ec2-user
    * run `redeploy` as justbehuman
  * to regenerate SSL certs:
    * run `/etc/certbot-auto --debug -v --server https://acme-v02.api.letsencrypt.org/directory certonly -d detrashers.org`
  * ClamAV is installed as an antivirus
    * https://www.clamav.net/documents/installing-clamav for installation instructions
    * note - this is not up and running yet


# Technical Questions



# Architectural/Design Questions


* So, what do we need to do to set up a Wiki that can be modified by any authenticated user simultaneously?
* Websockets?? That would be really really cool...
* I'm almost certain that Rails 5 added support for websockets



# TO DO

* identify and test all permissions requirements
  * added: 20190811
  * completed:
  * checkin- 20200314 - still not done

* get document signing/uploading running
  * subtasks:
    * upload: DONE 20200328
    * display: IN PROGRESS 20200328
    * sign
    * email






### Ignore this stuff - I stole this from a rails dev's list of "most used gems"
### and am just using it for easy reference/a reminder to look into the rest of these in the future


Security audit tools:
https://github.com/hardhatdigital/rails-security-audit

Active Storage permanent URL's:
https://vitobotta.com/2019/11/17/rails-active-storage-permanent-urls-with-no-redirects-digital-ocean-spaces-cloudflare/

Invisible Captcha to catch bots:
https://github.com/markets/invisible_captcha

Displaying PDF's:
https://nts.strzibny.name/displaying-downloading-streaming-files-with-active-storage/

I've definitely reduced the amount of gems I use compared to last year.

####Base rails
dotenv-rails
puma
webpacker
turbolinks


####Users
devise
omniauth
pundit
valid_email2


####ActiveStorage
aws-sdk-s3
vips (Instead of the default image_processing gem)
ActiveJob
sidekiq
sidekiq-cron

####Logging and exception tracking
lograge
sentry-raven


####Making SEO easier
meta-tags
friendly_id


####Encouraging I18n usage.
http_accept_language


####Cleaner views
draper
simple_form
premailer-rails


####For Development
powder
puma-dev - Not really a gem, but I love using it to turn on my rails projects.
puma-ngrok-tunnel
rubocop
rack-mini-profiler


####For Testing
rspec-rails
factory_bot_rails
faker
webmock
simplecov
pig-ci-rails
formulaic


####Admin tools
ActiveAdmin
