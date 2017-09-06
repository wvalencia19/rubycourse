# Scaffolding

* Is a code generator for entities
* Generates a simple prototype to work with it
* scaffold creates CRUD
* http://localhost:3000/cars/
* http://localhost:3000/cars/new
* scaffold creates: migration, model, routes, controller with actions, views

* Is possible generate json response http://localhost:3000/cars.json
```
rails g scaffold car make color year:integer #car is entitie, others are the columns, defult type is *** string ***
```
* scaffold creates only the ruby code, but not make changes in the database

```
rake db:migrate #create the code on DB
```
# Database Setup and SQLite

* By default rails use SQLite
* SQLite doesn't have a server, is just a file

```
rails db
```
