## Dyvo Server

* Source code is on [Github](https://github.com/rossfoley/dyvo-server).
* [Production](http://dyvo.herokuapp.com/) on Heroku


## Project Setup

You will need the following installed:

* MongoDB
* Rails (RVM preferred)
* Bundler

You can get these via [Homebrew](http://mxcl.github.io/homebrew/) and you'll find RVM [here](https://rvm.io/).

## Environment Setup

1. `bundle install` 
    - Installs all the ruby gems needed for the project
2. `rails s` 
    - Run the test server
3. `rails c` 
    - Run the rails console
4. Install this [Chrome extension](https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg?hl=en-US) to allow for easy debugging with the Chrome Dev Tools

## Implementing a New API Endpoint

1. Create a controller in the `app/controllers/api` directory that extends from `Api::BaseController`
2. Create a tests for the controller in the `spec/controllers/api` directory
3. Add the appropriate routes to `config/routes.rb`

## Team Roles

* Ross Foley: Server Lead, Android Developer
* Chris Hanna: Android Developer
* Dan True: Android Developer

