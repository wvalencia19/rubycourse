# Show RESTfull Action

1.  Retrieve specific post based on id parameter passed in (as part of URL)
1.  (Implicit) Look for show.html.erb template to render response

```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts/1
  # GET /posts/1.json
  def show
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

```

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Title:</strong>
  <%= @post.title %>
</p>

<p>
  <strong>Content:</strong>
  <%= @post.content %>
</p>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```
```json
#show.json.jbuilder
json.extract! @post, :id, :title, :content, :created_at, :updated_at
```

```json
{  
   "id":1,
   "title":"Prueba",
   "content":"esto es una prueba",
   "created_at":"2018-06-15T20:18:48.001Z",
   "updated_at":"2018-06-15T20:18:48.001Z"
}
```

## respond_to

* Rails helper that specifies how to respond to a request based on a request format
* Takes an optional block where the argument is the format (e.g. html, json, xml etc.)
* Block specifies how to handle each format: •  format.format_name – matching template
  1. format.format_name
  1. { do_something_other_than_just_displaying_the_ matching_template }

## redirect_to 

* Instead of rendering a template – send a response to the browser: “Go here!”
* Usually takes a (full) URL as a parameter
* Could either be a regular URL (like http://google.com) or a named route
* If the parameter is an object – Rails will attempt to generate a URL for that object


# Destroy action

```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

```

## Why redirect?

* Even though redirect involves an extra step (roundtrip to the browser) – sometimes it just makes sense
* Obvious examples:
  1. When you want the client to be able to bookmark a certain page or you don’t have a specific template to show (destroy action) and instead want the client to go to a generic page (index)


# new RESTful action

1.  Create a new empty post object
1.  (Implicit) Look for new.html.erb

```ruby
class PostsController < ApplicationController

 # GET /posts/new
  def new
    @post = Post.new
  end

```

```html
<h1>New Post</h1>

<%= render 'form' %>

<%= link_to 'Back', posts_path %>
  
 ```
 
# create RESTful action

1.  Create a new post object with parameters that were passed from the new form
1.  Try to save the object to the database
1.  If successful, redirect to show template
1.  If unsuccessful, render new action (template - again)
  * Why would it not be successful? Validations did not pass for example.
 
## Summary
* new action provides a form to be filled out to create a new resource
* create action accepts parameters passed in from filling out the form in the new action


# Strong parameters

With [strong parameters](http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters), Action Controller parameters are forbidden to be used in Active Model mass assignments until they have been whitelisted. This means that you'll have to make a conscious decision about which attributes to allow for mass update. This is a better security practice to help prevent accidentally allowing users to update sensitive model attributes.


```ruby

class PostsController < ApplicationController
  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
 end
 ```
 
 # Flash
 
* Problem: We want to redirect a user to a different page on our site, but at the same time give him some sort of a message? For example, “Post created!”
* Solution: flash – a hash where the data you put in persists for exactly ONE request AFTER the current request.
* You can put your content into flash by doing flash[:attribute] = value
* Two very common attributes are :notice (good) and :alert (bad)
* These are so common in fact, that the redirect_to takes a :notice or :alert keys


# Edit RESTful action

1.  Retrieve a post object based on the id provided (as part of the URl)
1.  (Implicit) Look for edit.html.erb

```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  # GET /posts/1/edit
    def edit
    end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
end

```
```html
<h1>Editing Post</h1>

<%= render 'form' %>

<%= link_to 'Show', @post %> |
<%= link_to 'Back', posts_path %>
  
```

# Update RESTful Action

1.  Retrieve an existing post using id parameter
1.  Update post object with (strong) parameters that were
passed from the edit form
1.  Try to (re)save the object to the database
1.  If successful, redirect to show template
1.  If unsuccessful, render edit action (template) again


```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
```

## Summary
1. edit/update is very similar to new/create except there is an id of an existing resource that is being kept track of
1. Strong parameters apply to updating a resource as well as creating one


# Partials

Partials: DRY (Don’t Repeat Yourself)
* Rails encourages the DRY principle
* We already know about the application.html.erb, which enables you to maintain layout code for the entire application in one place (more on this later)
* It would also be nice to reuse snippets of view code in multiple templates
* For example, edit and new forms – are they really that much different?
* Partials are similar to regular templates, but they have a more refined set of capabilities
* Named with underscore (_) as the leading character
* Rendered with render ‘partialname’ (no underscore)
* render also accepts a second argument, a hash of local variables used in the partial

## Object Partial
* Similar to passing local variables, you can also render a specific object
* <%= render @post %> will render a partial in app/ views/posts/_post.html.erb and automatically assign a local variable post

```ruby
<%= render @posts %>
is equivalent to
<% @posts.each do |post| %>
  <%= render post %>
<% end %>
```
```html
<%= form_for(@post) do |f| %>
  <% if @post.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@post.errors.count, "error") %> prohibited this post from being saved:</h2>

      <ul>
      <% @post.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= f.label :title, "Heading" %><br>
    <%= f.text_field :title, placeholder: "Have a great title?" %>
  </div>
  <div class="field">
    <%= f.label :content %><br>
    <%= f.text_area :content, size: "10x3" %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>

```

```ruby
class Post < ActiveRecord::Base
	validates :title, presence: true
end

```

# Form helpers

```hmtl
<%= form_for(@post) do |f| %>
  <% if @post.errors.any? %>
  <% end %>

  <div class="field">
    <%= f.label :title, "Heading" %><br>
    <%= f.text_field :title, placeholder: "Have a great title?" %>
  </div>
  <div class="field">
    <%= f.label :content %><br>
    <%= f.text_area :content, size: "10x3" %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>

```

* Form with parameters that match up with model’s attributes
*  Submit button for submitting the form


## form_for
* Generates a form tag for passed in object
* Unlike a regular HTML form, Rails uses POST by default
* This of course makes a lot of sense:
	1. Your password is not passed as part of your URL
	1.  Anything that will end up modifying data on the server should definitely be a POST and not GET
	

## f.label
* Outputs HTML label tag for the provided attribute
* To customize label description, pass in a string as a second parameter

## f.text_field
* Generates input type=“text” field
* Use:placeholderhashentrytospecifyaplaceholder (hint) to be displayed inside the field until the user provides a value

## f.text_area
* Similar to f.text_field, but for a text area instead of a text field input (default: 40 cols x 20 rows)
* Can specify a different size (colsXrows) with a :size attribute


## Date Helpers
### f.date_select
•  Set of select tags (year, month, day) pre-selected for accessing an attribute in the DB. Many formatting options f.time_select
### f.datetime_select
### distance_of_time_in_words_to_now
* And many many more...
* See ActionView::Helpers::DateHelper [docs](http://api.rubyonrails.org/classes/ActionView/Helpers/ DateHelper.html)

## Others

* search_field
* telephone_field ²  url_field
* email_field
* number_field
* range_field

# f.submit
* Submit button
* Accepts the name of the submit button as its first argument
* If you don’t provide a name – generates one based on the model and type of action, e.g. “Create Post” or “Update Post”

 http://guides.rubyonrails.org/form_helpers.html
 
# More on Layouts
1. Layout named application.html.erb is applied by default as a shell for any view template
1. Layout that matches the name of a controller is applied if present (overriding 1. above)
1. You can use layout method inside controller (outside any action) to set a layout for the entire controller layout ‘some_layout’
 
 
## Layouts During Rendering
* You can include a layout for a specific action with an explicit call to render inside the action render layout: ‘my_layout’
* If you don’t want a layout (for some reason) – just pass false instead of layout name render layout: false
   
## Summary
* Form helpers are a quick way to generate forms as well as form elements
* Layouts let you display a common “shell” around application template or around particular actions or resources
