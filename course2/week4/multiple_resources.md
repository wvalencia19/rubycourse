# Multiple Resources

### Pull out flash messages into layout

```html
<%= flash.each do |key, value|  %>
  <p id='<%= key %>'><%= value %> </p>
<%= end %>
```
*  flash keys - :notice, :alert

### scaffold_controller
Generate controller from existing model

```
rails g scaffold_controller book name author

```

# Nested resources

* We can scaffold a regular RESTful controller for notes as well, but...
* Note resource depends on the book resource
* In other words, when doing anything with the notes resources, we have to be talking about a specific book for it to be meaningful
* Rails calls such secondary resources “Nested Resources”

## config/routes.rb

* Nest notes inside books! 
* Paths to notes resources will have book id in them...

```ruby
Rails.application.routes.draw do
  resources :books do
    resources :notes
  end
  root to: "books#index"
end
```
* Routes Available So Far - Books

| HTTP Method        | Named Routes           | Parameters  | Controller Action| Purpose|
| ------------- |---------------| ------| ---------------- | -------|
| GET     | books_path | | index | List all |
| GET     | book_path      |   ID | show | Show one|
| GET | new_book_path      |     | new | Provide form to input new book |
| POST     | books_path | Record hash| create | Create new record (in DB) |
| GET     | edit_book_path      |   ID | edit |Provide form to edit book|
| PUT/PATCH | book_path      |   ID and Record hash  | update | Update record (in DB) |
| DELETE | book_path      |   ID  | destroy | Remove record |

* Routes Available So Far - Notes

| HTTP Method        | Named Routes           | Parameters  | Controller Action| Purpose|
| ------------- |---------------| ------| ---------------- | -------|
| GET     | book_notes_path | Book ID| index | List all |
| GET     | book_note_path      |   Book ID, Note ID | show | Show one|
| GET | new_book_note_path      |   Book ID  | new | Provide form to input new note |
| POST     | book_notes_path |Book ID, Record hash| create | Create new record (in DB) |
| GET     | edit_book_note_path      |   Book ID, Note ID | edit |Provide form to edit book|
| PUT/PATCH | book_note_path      |   Book ID, Note ID and Record hash | update | Update record (in DB) |
| DELETE | book_note_path      |   Book ID, Note ID  | destroy | Remove record |

* rake routes
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
```

## What Actions Do We Need For Notes?
* Notes will be shown inline on the book show page (books/show.html.erb), so we probably don’t need all seven actions in the notes controller
* The form for creating a note (usually provided by the new action) will be provided on the “book show” page
* create and destroy actions is all we need

## Restrict routes

```ruby
Rails.application.routes.draw do
  resources :books do
    resources :notes, only: [:create, :destroy]
  end
  root to: "books#index"
end
```

## notes controller
```ruby
class NotesController < ApplicationController
    before_action :set_book, only: [:create, :destroy]

    def create
        @note = @book.notes.new(note_params)
        if @note.save
            redirect_to @book, notice: "Note successfully added!"
        else
            redirect_to @book, alert: "Unable to add note!"
        end
    end

    def destroy
        @note = @book.notes.find(params[:id])
        @note.destroy
        redirect_to @book, notice: "Note deleted!"
    end

    private
    def set_book
        @book = Book.find(params[:book_id])
    end

    def note_params
        params.require(:note).permit(:title, :note)
    end
end
```
* create and destroy actions is all we need

## Embed nested resources into the parent view

* content_tag: Nice Rails helper to generate HTML content

 * simple_format: formats new lines as <br/>
 
 ```html
<div class="book">
 <%= content_tag :span, "#{@book.name} (#{@book.author})", class: "book-tittle" %>
 <%= link_to 'Edit', edit_book_path(@book) %>
</div>

<div id="notes">
  <%= 
  render @book.notes 
  #note partials
  %>
</div>

<div>
  <%= 
  #form for new note
  # nested resource [@book, @book.notes.new]
  form_for([@book, @book.notes.new]) do |f| 
  %>
    <div class="field">
      <%= f.label :tittle %>
      <%= f.text_field :tittle %>
    </div>
    <div class="field">
      <%= f.label :note %>
      <%= f.text_area :note, size: "25x5" %>
    </div>

    <div class="action">
      <%= f.submit "Add New Note" %>
    </div>
  <% end %>
</div>
<%= link_to 'Back', books_path%>
```
 
* Remember to always pass the parent and the child into the form_for and link_to helpers
* Usecontent_tag,simple_formatandvarious date-related helpers to simplify development


