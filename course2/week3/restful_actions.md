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
