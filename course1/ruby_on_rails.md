
# Why use rails?
* Convention over configuration (COC)
* Two ways 
 1. Configurate all
 2. Rely on convenction that have been established
* Less code, the framework assumns some conventions for you
* Learn it once, always the same structure
* Database abstraction layer(ORM)
* Agile - Friendly
* Don't repeat yourself
* Cross platform
* Open source
* Modular

### SQLite
* User by default SQLite.
### Model View Controller (MVC)
* Model: represents the data of application is working with.
* View: visual representation of the data.(html,json, xml)
* Controller: manage the relation between model and view.

### Create aplication
* Bundler is the gem manager
* Rails create all path structure
* Provides a built-in web server

### Runs server
rails server or rails s
* Is not necesary restart server when you make changes

```
rails new app_name
```
### Directory structure
* app: contains Controllers, Views and Models (and helpers)
* config: configuration files
* db: files for database migration scripts
* public: static files, like regular HTML files
* Gemfile and Gemfile.lock: Files used by the bundler, specify the dependences and the interaction between those dependences.
* Server **looks** inside public directory before looking anywhere else.

### Controllers

* Controllers contains **actions**,controllers are basically **classes** and contain which are referred to as actions.
* Orchestrate web request
* rails generate controller_name [action1 action2]
* May substitue generate for g
* Example: rails g controller greeter hello

```
rails g controller greeter hello
Running via Spring preloader in process 6482
      create  app/controllers/greeter_controller.rb -> controller
       route  get 'greeter/hello'
      invoke  erb
      create    app/views/greeter
      create    app/views/greeter/hello.html.erb -> view
      invoke  test_unit
      create    test/controllers/greeter_controller_test.rb
      invoke  helper
      create    app/helpers/greeter_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/greeter.coffee
      invoke    scss
      create      app/assets/stylesheets/greeter.scss
```

### ERB (Embedded Ruby)
* The file generated looks like a html file, but has erb extension
* ERB is a templating library(similar to JSP) lets embed Ruby code inside HTML
* Two tag patterns:
 1. <% ... ruby code %>  -> Evaluates ruby code
 2. <%= ... ruby code %>  -> Output evaluates ruby code
 
 ```html
<% random_names = ["Alex", "Joe", "Michael"] %>
<h1>Greetings, <%= random_names.sample %></h1>
<p>The time now is <%= Time.now %></p>
 ```
 * How looks like controller?
 ```ruby
 class GreeterController < ApplicationController
  def hello
  end
end
 ```
