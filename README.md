# README

Ruby 2.6.2

Rails 5.2

# CURRENT DEPLOYMENT STATUS
* deployed to EC2 t2.micro instance with postgres db
  * Ruby 2.6.3
  * Rails 5.2
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
* What is the best way to efficiently limit db calls while still maintaining permissions for edit/delete of posts and comments?
* User.edit_delete_permissions that accepts the comment/post ID and a type identifier?
* what logging/metric framework do I want to use? What's the process to get set up with grafana in ruby/rails?



# BIG TASKS STILL OUTSTANDING

* identify and test all permissions requirements
  * added: 20190811
  * completed:

* milestones as a model need to be dramatically improved
  * probably need to add a /show page back in
  * need participant count, due date (which must be <= problem due date)
  * added: 20190811
  * completed:

# Known small bugs/changes needed
* devise user registration handlers redirect to /users and need to be overridden somehow
  * 20190812
* nginx does not start on system startup for current AMI
  * 20190815

# Arren todo:
 * home page design
  - update style
  - clickable problem cards (remove links)
    - edit and delete from show page
  - tabs for near me / my problems
    - near me tab has filter by category
 * fix up problem show page
 * Posts
    - write code once for both problems/ milestones
 * Comments
    - write code once for both problems/ milestones
 * sticky footer -- DONE
 * open specific problem tab on load and after modal submit
 * get rid of my problems page
 * filters on hp by problem title, category, sort by due date

 * Action Mailer Design -- wait for later
