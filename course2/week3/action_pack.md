# Action Pack

Action pack is the combinaition between ActionController + ActionView

```
rails new my_blog
rails g scaffold post tittle context:text
rake db:migrate
```

## Scaffolding creates: 
1. Migration
1. Model 
1. Routes
1. RestfulController
1. Views
1. More...

ActionPack: Routes, RestfulController, Views

## ActionView: ERB

* HTML file with an .erb extension
* ERb is a templating library (similar to JSP) that lets you embed Ruby into your html
* Two tag patterns to learn:
* <% ...ruby code... %> - evaluate Ruby code
* <%= ...ruby code... %> - output evaluated Ruby code

***And of course, there are many view helpers that assist in code creation, like link_to...***

## Action Controller
* Ruby class containing one or more actions
* Each action is responsible for responding to a request to perform some task
* Unless otherwise stated – when an action is finished firing (or even if the action is not physically present) it renders a view with the same name as the action
* The action always needs to be mapped in routes.rb
 
## Routes
```ruby
Rails.application.routes.draw do
  resources :posts
end
```
Is that it?! One line lets you route to actions that list, create, edit and destroy blog postings? Impossible... (***Convention Over Configuration***)

## REST and Rails

***Re***presentational ***S***tate ***T***ransfer

* Check out the following great resource on REST:
http://www.xfront.com/REST-Web-Services.html

REST = Resources
* REST is all about resources ²  You should be to able to:
1. List available resources
1. Show a specific resource
1. Destroy an existing resource
1. Provide a way to create a new resource
1. Create a new resource
1. Provide a way to update an existing resource
1. Update an existing resource

REST: A Simple Rails Convention:
```ruby
 class PostController < ApplicationController
 
  # GET /posts
  def index

  # GET /posts/1
  def show

  # DELETE /posts/1
  def destroy

  # GET /post/new
  def new

  # GET /posts/1/edit
  def edit

  # POST /posts
  def create

  #PATH/PUT /posts/1
  def update
 end

```



