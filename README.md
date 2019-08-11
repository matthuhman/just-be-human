# README

Ruby 2.6.2

Rails 5.2




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



# Big TO-DO list

* ~~get comments fully functioning~~
  * added: 20190811
  * completed: 20190811
* get google maps integration functioning on the back end
  * still need to fully define use cases
  * creds have been acquired!
  * added: 20190811
  * completed: 
* ~~get the service deployed into Elastic Beanstalk~~
  * added: 20190811
  * completed: 20190811
  * NOTE: NOT USING EBS- HARD-DEPLOYED TO EC2
  * recommend using an AMI for now
* ~~get the domain host changed from gandi to AWS~~
  * added: 20190811
  * completed: 20190811
* get a web server running on port 80
  * added: 20190811
  * completed:
* set up a permanent postgres db
  * added: 20190811
  * completed: 
* identify and test all permissions requirements
  * added: 20190811
  * completed: 
* create final AMI (not final code, but final environment config)
  * added: 20190811
  * completed: 



# Known bugs and changes needed (big and small)
* not logged in, directs to /problems, then throws error
  * 20190811
* comments#new back button redirects to comments#index instead of parent post
  * 20190811
* remove all public references to email address on application, also restrict API access to emails
  * 20190811
* milestones as a model need to be dramatically improved
  * probably need to add a /show page back in
  * need participant count, due date (which must be <= problem due date)
  * 20190811