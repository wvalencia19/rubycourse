# Authentication

## What Happened To The Users?
* The books/notes stuff is working pretty nicely, but everybody can see and modify everybody else’s books and notes?
* We need the two security ‘A’s:
  1. Authentication: Do we know who the user is and are his credentials valid?
  1. Authorization: Provide access only to the books/notes a particular logged-in user is authorized to modify/see
  
## Authentication Summary

**has_secure_password** to the rescue!

1. Enable (uncomment) bcrypt-ruby (Gemfile)
  * Run $bundle (install)
1. Make sure password_digest is table column
1. Account for password (not password_digest) inside strong parameters list in the controller if you plan to use mass assignment when creating users
1. No need for password column in the table (virtual attribute)

## has_secure_password

Add has_secure_password on model

```ruby
  class Reviewer < ActiveRecord::Base
    has_secure_password
    has_many :books
  end
```

## How works?

```
rails c
Running via Spring preloader in process 5228
Loading development environment (Rails 4.2.8)
irb(main):001:0> Reviewer.column_names
=> ["id", "name", "password_digest", "created_at", "updated_at"]
irb(main):002:0> Reviewer.create! name: "Joe", password: "abc123"
   (0.1ms)  begin transaction
  SQL (3.3ms)  INSERT INTO "reviewers" ("name", "password_digest", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "Joe"], ["password_digest", "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThPAiH7jAb3c2"], ["created_at", "2018-07-19 19:36:16.756483"], ["updated_at", "2018-07-19 19:36:16.756483"]]
   (2.0ms)  commit transaction
=> #<Reviewer id: 1, name: "Joe", password_digest: "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThP...", created_at: "2018-07-19 19:36:16", updated_at: "2018-07-19 19:36:16">
irb(main):003:0> joe = Reviewer.find_by_name "Jose"
  Reviewer Load (0.3ms)  SELECT  "reviewers".* FROM "reviewers" WHERE "reviewers"."name" = ? LIMIT 1  [["name", "Jose"]]
=> nil
irb(main):004:0> joe = Reviewer.find_by_name "Joe"
  Reviewer Load (0.4ms)  SELECT  "reviewers".* FROM "reviewers" WHERE "reviewers"."name" = ? LIMIT 1  [["name", "Joe"]]
=> #<Reviewer id: 1, name: "Joe", password_digest: "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThP...", created_at: "2018-07-19 19:36:16", updated_at: "2018-07-19 19:36:16">
irb(main):005:0> joe.authenticate("dsfsf")
=> false
irb(main):006:0> joe.authenticate("abc123")
=> #<Reviewer id: 1, name: "Joe", password_digest: "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThP...", created_at: "2018-07-19 19:36:16", updated_at: "2018-07-19 19:36:16">
```

# Sessions and cookies

## HTTP Is A Stateless Protocol

* HTTP is a stateless protocol
  1. Each new request even from the same browser knows nothing about a previous request that was made
  1. This means that even if a user makes a request – he will be treated as unknown on all the subsequent requests
* Cookies and Sessions to the rescue (keep state)
* http://guides.rubyonrails.org/security.html#what- are-sessions-questionmark
 
## Sessions in Rails
* Session is created and made available through a session hash
* The server sends the browser a cookie with the session information, which the browser stores and sends back to the server on all subsequent requests (until the session ends)

## Restful Sessions Controller
* Session can be thought of as a resource – let’s go ahead and create a RESTful sessions controller
```
rails g controller sessions new create destroy -q
```

### config/routes.rb
```ruby
Rails.application.routes.draw do
  resources :books do
    resources :notes, only: [:create, :destroy]
  end
  root to: "books#index"

  resources :sessions, only:[:new, :create, :destroy]
end
```

## Sessions Controller Actions

* We can think of new action as login page and destroy as a logout page
* Thus, we’ll need new (and create) actions to create a session and destroy action to destroy a session
* Let’s map login/logout routes to make this more clear

```ruby
Rails.application.routes.draw do
  resources :books do
    resources :notes, only: [:create, :destroy]
  end
  root to: "books#index"

  resources :sessions, only:[:new, :create, :destroy]

  get "/login" => "sessions#new", as: "login"
  delete "/logout" => "sessions#destroy", as: "logout"
end
```
* 

 This lets us refer to these routes in our code as login_path/logout_path or login_url/logout_url...
 
 ## routes
 ```
 rake routes
     Prefix Verb   URI Pattern                         Controller#Action
 book_notes POST   /books/:book_id/notes(.:format)     notes#create
  book_note DELETE /books/:book_id/notes/:id(.:format) notes#destroy
      books GET    /books(.:format)                    books#index
            POST   /books(.:format)                    books#create
   new_book GET    /books/new(.:format)                books#new
  edit_book GET    /books/:id/edit(.:format)           books#edit
       book GET    /books/:id(.:format)                books#show
            PATCH  /books/:id(.:format)                books#update
            PUT    /books/:id(.:format)                books#update
            DELETE /books/:id(.:format)                books#destroy
       root GET    /                                   books#index
   sessions POST   /sessions(.:format)                 sessions#create
new_session GET    /sessions/new(.:format)             sessions#new
    session DELETE /sessions/:id(.:format)             sessions#destroy
      login GET    /login(.:format)                    sessions#new
     logout DELETE /logout(.:format)                   sessions#destroy
 ```
## Summary
* Sessions and cookies make the interaction between browser and server stateful
* You can think of Sessions as yet another resource
* Custom routes - http://guides.rubyonrails.org/routing.html

# Sessions controller and view

## views/sessions/new.html.erb

```html
  <h1>Login</h1>

<%= form_for(:reviewer, url: sessions_path) do |f| %>
    <div class="field"><%= f.label :name %> <br/> <%= f.text_field :name %></div>

    </p>

    <div class="field"><%= f.label :password %> <br/> <%= f.password_field :password %></div>

    <div class"actions"><%= f.submit "Login"%> </div>

<%end%>
  
```
## Sessions Controller

```ruby
class SessionsController < ApplicationController
  skip_before_action :ensure_login, only: [:new, :create]
  def new
    #Login Page - new.html.erb
  end

  def create
    reviewer = Reviewer.find_by(name: params[:reviewer][:name])
    password = params[:reviewer][:password]
    if reviewer && reviewer.authenticate(password)
      session[:reviewer_id] = reviewer.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      redirect_to login_path, alert: "Invalid username/password combination"
    end
  end

  def destroy
    reset_session 
    redirect_to login_path, notice: "Yoy have been logged out"
  end
end
```

## Locking Down The App
* We can have a before_action in the ApplicationController (from which all the other controllers inherit) that will make you login if you are not yet logged in
* But if everything is blocked off – how will we get to the login page? Hmm...
* Controllers can override before_action with skip_before_action

## application_controller.rb

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_login

  protected
  def ensure_login
    redirect_to login_path unless session[:reviewer_id]
  end
end
```
## sessions_controller.rb

```ruby
class SessionsController < ApplicationController
  skip_before_action :ensure_login, only: [:new, :create]
  def new
    #Login Page - new.html.erb
  end

  def create
    reviewer = Reviewer.find_by(name: params[:reviewer][:name])
    password = params[:reviewer][:password]
    if reviewer && reviewer.authenticate(password)
      session[:reviewer_id] = reviewer.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      redirect_to login_path, alert: "Invalid username/password combination"
    end
  end

  def destroy
    reset_session 
    redirect_to login_path, notice: "Yoy have been logged out"
  end
end
```
## Summary
* Login page corresponds to new action SessionsController, but uses attributes from Reviewer
* Lock down the app by specifying a before_action in ApplicationController
