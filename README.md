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



# Big TO-DO list

* Get comments fully functioning
* Get google maps integration functioning on the back end
  * user creation, what else?
* Get the service deployed into Elastic Beanstalk
* Get the domain host changed from gandi to AWS
