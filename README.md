# README

Ruby 2.6.2

Rails 5.2

# CURRENT DEPLOYMENT STATUS
* deployed to EC2 t3a.large instance with postgres RDS db
  * Ruby 2.6.2
  * Rails 6.0.0
  * rvm used for install


# ERB Breakdown
```
* User (self-explanatory)
  * has_many problems
  * has_many roles
  * has_many milestone_roles
  * has_many posts
  * has_many comments
* Problem (the basic construct for the platform)
  * belongs_to user
  * has_many roles (link table)
  * has_many milestones
  * has_many posts, as postable
* Milestone (essentially sub-problems)
  * belongs_to problem
  * has_many posts, as postable
  * has_many milestone_roles (link table w/ users)
* Role (link table b/t problems and users, has `level` integer for permissions)
  * belongs_to user
  * belongs_to problem
* MilestoneRole (link table b/t milestones and users, also has `level`)
  * belongs_to user
  * belongs_to problem
* Post
  * belongs_to user
  * belongs_to postable (
  * has_many comments
* Comment
  * belongs_to user
```
## Standalone models
```
* Cost (unrelated to other models)
  * used for storing daily/monthly cost data for display on /costs page
* Geopoint (unrelated to other models)
  * used for looking up the Lat/Lng of a given zip code (basically a cache)
```  


# Technical Questions

* how do I validate/edit params on user creation (edit the devise controller)
* getting user's location from their browser
* repurpose the search bar to change locations
* how/where is session data stored (e.g. if user changes locations, where does that get saved)




# Architectural/Design Questions


* I don't want to automatically delete a user's problems when that user deletes their account - what do I want to do to make sure we don't end up with orphaned problems that have no leader? And *how* do I do this?
* what logging/metric framework do I want to use? What's the process to get set up with grafana in ruby/rails?



# BIG TASKS STILL OUTSTANDING

* identify and test all permissions requirements
  * added: 20190811
  * completed:
  * checkin- 20190922 still not done, unfortunately... hopefully once we're released 



 * Action Mailer setup
  * added: 20190922
  * completed: 
