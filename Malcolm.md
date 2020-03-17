
Yo!!! So glad to finally be getting your eyes on this stuff!


## Environment Setup

The worst fucking part about programming, I know

* Homebrew
  * god save you if you work on a Mac and don't have this installed
* Ruby 2.6.2
  * installed and managed via `rbenv` - short for 'ruby environment' I assume
  * I think you get rbenv as a brew cask? I can't remember. Maybe you even pull it straight from github, it's been a while. A little googling will get you going in the right direction
  * `rbenv` allows you to easily download multiple versions of ruby and choose which one you want. Just set yourself up with `2.6.2` globally and you're golden
* Postgres 11.4
  * I don't remember how I installed it. Brew, maybe? idk
* Rails 6.0.2.1
  * this should get handled for you once you get ruby happy and can run the project


## Logical breakdown (corresponds with Models)
* User
  * self-explanatory
  * authentication is handled via a gem called `devise`
* Opportunity
  * the meat and potatoes of the software
  * represents a cleanup (the code was written to be more generic originally)
  * these are 'geocoded' meaning that their lat/long are known and can be used for geofencing
* OpportunityRole
  * join object for users and opportunities, also handles some of its own logic
  * contains info like the role level of the user, whether that user has RSVP'd, etc
* Waiver
  * user-uploadable waiver objects
  * "OpportunityWaiver" joins Opportunities and Waivers but is an entirely theoretical "model"
    * only exists as a join table and as a theoretical construct, does not have a file on disk
  * referenced by Signatures
* Signature
  * represents a user's signature of a waiver
  * not all cleanups will require waivers, but if there is a waiver, it must be signed
  * one signature per waiver
  * 'Authenticity' is marked by including a ton of info into a SHA256 hash at signature creation time
  * I'm honestly not sure if my system will hold up legally but I needed something cheap and easy and if it becomes a problem then I'll redo it
  * Waivers and Signatures are not complete yet - the back end for them *should* be done but the front end hasn't been hooked up yet
* Post and Comment
  * posts belong to opportunities, comments belong to posts
  * must be authenticated to see
* Conversation and Message
  * private messaging system, desperately needs front-end love
  * must be volunteers for the same cleanup to start a conversation with another user
* Leaderboard and Point
  * these are not finished yet and are on the list - I want to gamify the entire platform
  * right now I have Points being stored on Dynamo just because I love dynamo and I wanted an excuse to use it
* Requirement and RequirementRole
  * no longer used, I just kept them around for reference
  * honestly I should just delete them, they're still in source control. Maybe I'll do that this week
  * in the past, Opportunities had Requirements that had to be completed before the Opportunity itself could be completed
  * requirements could be volunteered for by one or more users, had independent due dates, their own categorization system, and more... it's kinda crazy how much code I've removed from this system since I first launched
  * basically I built out a complicated task management system and then lit it all on fire and got rid of it.....

## Basic repository structure breakdown:

### Most of the important files live in the ./app directory
* models are in `./app/models`
  * models that are relevant to ActiveRecord (Rails' ORM) will subclass `ApplicationRecord`
  * model files that do not subclass it (denoted by `class ExampleModel < ApplicationRecord`) are files that I'm generally using as java-ish static classes
    * the `Role` model ([link](app/models/role.rb)) is responsible for a lot of the "meat" of the business logic and is an example of this
    * static methods are denoted by the addition of `self.` to the method declaration
    * the `ReportedError` class is similar. It is a weird hybrid of an ActiveRecord-backed model and a static class
  * not all of my models are still used
  * models also have relationships with each other (correspond to FK's in databases)
    * the relationship definitions are always at the top of a model's class
    * for example, an Opportunity object `has_many :opportunity_roles, :requirements, :posts, :waivers, :signatures`
      * this allows for access to the waivers that are related to Opportunity `opportunity` by calling `opportunity.waivers` which would return an array in the case of a `has_many` relationship or an object in the case of a `belongs_to` relationship
      * if the relationship is many-to-many, you will see a `has_many :siblings, through: :join_object` call where `:join_object` represents both a ruby object and a corresponding join table in active record (see [opportunity_role.rb](app/models/opportunity_role.rb) and what [`opportunity_roles` look like in `schema.rb`](db/schema.rb))
* view files are structured like so: `./app/views/*controller_name*/*controller_action*`
  * mapping of views requires the controller action and its corresponding view's file name to be identical
  * mapping is automatic
  * all views are server-side rendered (it doesn't have to be this way, but embedded ruby is pretty dope)
  * files with the `.erb` file extension allow the execution of ruby code in the view
    * embedded ruby code is wrapped in `<% tags without an = are invisible %>` or `<%= "tags with = print to the view" %>`
* controller files are in `./app/controllers`
  * you know what controllers do :laugh:
  * Rails tries desperately to enforce serious use of HTTP methods, and by and large if you let it do its thing it will do it automatically
  * lots of my `OpportunitiesController` code for interacting with opportunities is SUPER NOT RAILSY at all and is frankly kinda shitty code. It works well enough, but it's not particularly RESTful - I use get requests for a lot of the interactions just because it's easier and I'm not worried about the info being in the URL
  * controllers are mapped to url's via a schema laid out in `./config/routes.rb`

### But what about the database?
* the local database and all relevant information about it live in `./db`
* ActiveRecord manages the database schema for you, found in `./db/schema.rb`
  * the `schema.rb` file is autogenerated - don't edit
  * `migration_name.rb` files are used to make changes to the `schema.rb` file - these are found in `./db/migrate`
  * these files are created via some fun rails shit, more on this later
* the database is Postgres 10.something - I don't remember
* the ActiveRecord ORM is not particularly performant, but damn is it easy to get up and running

### And configuration?
* `configuration_name.rb` files live in `./config`
* these files get run automatically on rails startup and are used for system configuration
* like basically everything else, these are all ruby files (with some occasional `.yml` thrown in for fun)
* you generally don't need to mess around in here too often, my application is simple enough that the default configuration is generally good enough to stay out of my way haha
  * the files in the root of the `./config` directory are generally all Rails config files
  * `./config/environments` contains ruby file that allows for environment-specific configuration (dev, test, prod, etc)
  * `./config/initializers` has configuration for ruby "gems" - the ruby name for their package repository/management system
  * I don't know that I've really touched the `locales` or `webpack` directories - they both scare me hahaha






## Fun Rails shit

* so, Rails is super powerful, and the Rails CLI is part of what makes developing Rails so much fun
* a good Rails developer (not something I consider myself) lives on the command line
* the `rails` command is used to do everything
  * wanna start your server?
    * `rails s` (`s` is short for `server`)
  * wanna create a new model?
    * `rails g model Modelname`
    * it's waiting for you in the models directory
  * wanna create a database migration?
    * `rails g migration ModifySchemaUsingThisMigration`
      * this will create a timestamped migration file in `./db/migrate`
      * `up` and `down` methods in migration files give you the ability to easily roll back migrations, which my project cannot do because I used `change` instead and wrote a lot of my migrations manually
  * you created your migration and it's ready, wanna run it?
    * `rails db:migrate`
    * boom, your changes will be reflected in `./db/schema.rb`
  * wanna scaffold out an entire mvc framework for yourself?
    * `rails g scaffold ModelName`
    * I think this will build you a full CRUD-enabled MVC framework built around a model with the name you specified
    * if you added a bunch of arguments onto the end of your command, you can have it specify all the attributes of the model, and the controller actions you wanted, and all kinds of crazy shit, but I'm not that much of a power user
* Rails Gems
  * the framework by which you can use other people's code
  * ruby gems are managed via the `./Gemfile` in the root of the project directory
  * [if you want to do it, chances are there's a gem that already does](rubygems.org)
  * to install a new gem, add a `gem 'gemName'` to the Gemfile and optionally add versioning controls by adding `, '~> 1' to get major version 1, '>= 1' for gte, '1.0' for 1.0`
  * run `bundle install` to install any new gems you add, or remove any that have been taken out
* general thoughts
  * ruby is `snake_case` except for references to a `ModelName` - but model filenames are still `snake_cased` - don't ask me :laugh:
  * the `:variable_name` syntax (with the colon at the beginning or end) denotes a "symbol"
    * to be succinct, symbols are just easy references to functions that Rails handles for you
  * I'm really bad about writing "railsy" code - I'm a java developer and I wrote this shit by myself, so definitely don't assume that I've done anything in a way that would make a real Rails developer happy
  * You can do a ton of functional programming with ruby and rails but I don't think that way so I don't generally use those features. My loss I guess.
