# README

Ruby 2.6.2

Rails 5.2




# Technical Questions

* how do I validate/edit params on user creation (edit the devise controller)
* getting user's location from their browser
* repurpose the search bar to change locations
* how/where is session data stored (e.g. if user changes locations, where does that get saved)




# Architectural/Design Questions

* should a problem have its own columns for number of people participating/number of people still needed, or should it be dynamically calculated based on the number of roles with a level > 3?
* I don't want to automatically delete a user's problems when that user deletes their account - what do I want to do to make sure we don't end up with orphaned problems that have no leader? And *how* do I do this?
