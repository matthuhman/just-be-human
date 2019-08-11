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

* Get comments fully functioning
  * added: 20190811
  * completed: 
* Get google maps integration functioning on the back end
  * still need to fully define use cases
  * added: 20190811
  * completed: 
* Get the service deployed into Elastic Beanstalk
  * added: 20190811
  * copmleted:
* Get the domain host changed from gandi to AWS
  * added: 20190811
  * completed: 
