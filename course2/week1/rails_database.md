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
.help
.tables. #show tables
.headers on #show column names on select result
.mode columns # organizes the columns
.exit
```

# Migrations
* How monitor and undo the changes on database?
* Is simple switch from one database to other
* ActiveRecord::Migration
* 20170905042137_create_cars.rb ->20170905042137:timestamp, create_cars: ruby class

```ruby
class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :make
      t.string :color
      t.integer :year

      t.timestamps null: false
    end
  end
end
```

### Create migrations
* Is possible create migrations by hand
* Scaffold creates a migrations (unless passed --no-migration flag)
* No two migrations can have the same class name
* You run ***rake db:migrate*** to apply all migrations in db/migrate folder in timestamp order
* Migration code mantains a table called ***schema_migrations*** table with one column called version
* Version is the timestamp
* When we run again ***rake db:migrate***, if the version already exists in ***schema_migrations*** nothing is going to happen in the database
* Other two methods:
  1. ***def up:*** Generate db schema changes
  2. ***def down:*** Undo the changes introduced by the up method
* Or, just ***change*** method can guess how to undo changes (most of the time)

* Database independence: not specific data types, let you specify logical data types.
* Is possible define other three columns:
  1. ***null:*** true or false
  2. ***limit:*** size
  3. ***default:*** value (is possible calculate, only applies when the migration runs, not when one register is added)
* Decimal column options(optionally) take other two options
  1. ***precision:*** values -> total number of digits stored
  2. ***scale:*** where to put decimal point -> example: precision 5 and scale 2 can store -999.99 to 999.99
  
  ### Creating and Modifying Tables and Columns
  
  * By convention tables are named in plural
  * The entitie is creted in singular
  * Id column is created automatically to be used as primary key
  * automatically are created created_at and updated_at
