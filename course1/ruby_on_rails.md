
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

# SQLite
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

# Controllers

* Controllers contains **actions**,controllers are basically **classes** and contain which are referred to as actions.
* Orchestrate web request
* rails generate controller_name [action1 action2]
* May substitue generate for g
* By convention, controllers are named plural and model is named singular
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
# Routes* 
* The web request needs to get routed to the controller.
* How did the hello action work?
* First request -> second router -> controller <-> model <-> DB  controller -> view
* All routes need be configurated on config/routes.rb 
* root 'courses#index' -> convert that route in the root for the page

```ruby
#get 'greeter/hello' #greeter is controller, hello is action

get 'greeter/hello' => "greeter#hello" 
get 'greeter/goodbye'
```

### Rake
* Rake is Ruby's build language
* Is similar to ant from java
* Is Ruby's make
* No XML, written entirely in ruby
* Rails uses rake to automate app-related task: Database, runing test, etc
* rake --tasks ->list the different tasks
* rake --describe task_name -> describe individual task

### Action (methods) inside controller
* If action method is not doing anything(empty), we can remove it
* Still shows the view
* The view should have as little ruby code as possible.
* The logic must be inside controller
* Every new request will create a new instance variable, alternatives: session or database

Controller
```ruby
class GreeterController < ApplicationController
  def hello
    random_names = ["Alex", "Joe", "Michael"]
    @name = random_names.sample
    @time = Time.now
    @times_displayed ||= 0
    @times_displayed += 1
  end
end
```
### Helpers
* @time variable is disponible inside controller.
* What happends if we want format how the time looks?
 * Should that code go in the view? **Not reusable**
 * Controller?
 * Helpers are really view helpers
 * The helpers are avialable in any view
 
 ```ruby
 module GreeterHelper
  def formmated_time(time)
    time.strftime("%I:%M%p")
  end
end
 ```
 ### Ruby built-in helpers
 * link_to -> link_to name path
 * Path can be a regular string or a route defined in routes.rb, the route will be end with _ulr(full path) or _path(relative)
 * For the route, take the prefix from routes.rb and combined wiht _url or _path
 * People prefer _path
 * The full path (_url) is required in case of redirection

```ruby
<p><%= link_to "Google", "http://www.google.com" %></p>
<p><%= link_to "Goodbye", greeter_hello_path %></p>
```

 ### HttParty

* https://rubygems.org
* RubyGems : Is a package manager for Ruby.
* gem list: Shows de gems intalled
* gem list httparty : check if a specific gem is already installed
* gem install httparty : install gem httparty
* gem list httparty -d : more information about gem
* Httparty is a restful webservice client
* Httparty has automatica parsing of json or xml into ruby hashes or arrays
* Provides support for:
 1. Basic http autentication
 2. Default request query parameters

### Restful web services
* Simple web services implemented using HTTP(and principles fo rest):
 1. Have a base URI
 2. Support data exchange format like XML  and JSON
 3. Support a set the http operations(GET, POST, etc)
 
 ```ruby
require 'httparty'
require 'pp'

class Coursera
  include HTTParty

  base_uri 'https://api.coursera.org/api/catalog.v1/courses'
  default_params fields: "smallIcon,shortDescription", q: "search"
  format :json

  def self.for term
    get("", query: { query: term})["elements"]
  end
end

pp Coursera.for "python"
 ```
 
### Bundler
* Provides a consistent enviroment for Ruby projects by tracking and installing the exact gems and versions that are needed.
* httbundoler.io
* Preferred way to manage gem dependecies in Rails.
* Run bundle install or simply bundle after specifying a new gem in the Gemfile 
* Run bundle update when modifying a version of a gem.
* If you don't specify version, you will get the last.
* You can specific version or approximate version
* You can instruct rails to only load certain gems in specific Rails enviroments.
* Bundle also loads the gems, It doesn't just download it from the internet.

```ruby
gem "nokogiri" # last version
gem "rails", "3.0.0.beta3" #specific
gem "rack", ">=1.0" #range
gem "thin", ">=1.1", "<=2.0"
gem "thin", "~>1.1" #same as above

#Pessimistic version constraint: drop the final digit, then increment to get the upper limit version number.

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
```
* Is possible config how will be named the require

```ruby
gem 'sqlite3-ruby' require: 'sqlite3' 
```

* Gemfile.lock : Constains the exact version installed for bundle
* bundle exec : This command executes the command, making all gems specified in the Gemfile(5) available to require in Ruby programs.

# Example

* With params is possible get data from de url
### Controller

```ruby
class CoursesController < ApplicationController
  def index
    @search_term = params[:looking_for] || 'learn'
    @courses = Coursera.for(@search_term)
  end
end
```

### Model

```ruby
class Coursera
  include HTTParty

  base_uri 'https://api.coursera.org/api/courses.v1?'
  default_params fields: "smallIcon,shortDescription", q: "search"
  format :json

  def self.for term
    get("", query: { query: term})["elements"]
  end
end
```

### View

```ruby
<h1>Searching for - <%= @search_term %></h1>

<table border="1">
  <tr>
    <th>Image</th>
    <th>Name</th>
    <th>Description</th>
  </tr>
  <% @courses.each do |course| %>
      <tr class=<%= cycle('even', 'odd') %>>
        <td><%= image_tag(course["smallIcon"])%></td>
        <td><%= course["name"] %></td>
        <td><%= course["shortDescription"] %></td>
      </tr>
  <% end %>
</table>
```

* The views are writing inside the body  from the file view/layouts/application.html.erb
* Inside application.html.erb is possible define which css file use
* scss is not css, but support all css properties and more, you could css file inside scss

```css
table {
  border-collapse: collapse;
}

td {
  padding: 12px;
}

.even {
  background-color: #D6E1C3;
}
```
# Deploying to Heroku

* Heroku os a PasS(Platform as a Service)
* Download heroku toolbelt -> Command line, allows manage your heroku apllication
* Heroku use **postgres** and recommend **rails_12factor ** 
* Put sqlite gem into development group and "heroku" gems in production

```ruby
gem 'sqlite3', group: :development

group :production do
  gem 'pg'
  gem 'rails_12factor'
end
```

### Heroku commands

```
heroku login
Enter your Heroku credentials:
Email: wilval7126@gmail.com
Password: ***************
Logged in as wilval7126@gmail.com

heroku create search-coursera-learn1
Creating ⬢ search-coursera-learn1... done
https://search-coursera-learn1.herokuapp.com/ | https://git.heroku.com/search-coursera-learn1.git
#Above adds remote on git for heroku
git push heroku master
```

# Black Box testing
* The idea is don't care by the language of the application
* https://github.com/jhu-ep-coursera/fullstack-course1-module3-blackbox-testing
* Enter RSpec + Capybara ruby gems. When these 2 frameworks come together, you can write very intuitive and expressive tests.

```
rspec --format documentation
```
### phantomJS
* Is a headless browser
* Capybara has a gem called poltergeist, this is a phantomJS driver for Capybara

```ruby
Capybara.default_driver = :selenium -> for test with firefox
# Capybara.default_driver = :poltergeist -> for test with visual browser

Capybara.app_host = "http://search-coursera-jhu.herokuapp.com/"

describe "Coursera App" do

  describe "visit root" do
  	before { visit '/' }
    
    it "displays 'Johns Hopkins' (default)" do
      expect(page).to have_content 'Johns Hopkins'
    end

    it "displays table element that has a row with 3 columns" do
      expect(page).to have_selector(:xpath, "//table//tr[count(td)=3]")
    end

    it "column 1 should have the thumbnail inside img tag" do
      expect(page).to have_selector(:xpath, "//table//tr/td[1]//img")
    end
  end

  it "displays 'The Meat We Eat' when looking_for=diet" do
    visit "?looking_for=diet"
    expect(page).to have_content 'The Meat We Eat'  	
  end

end
```
### Debugging rails applications
* heroku logs -> see logs from heroku

