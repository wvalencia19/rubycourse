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

```ruby
.schema cars #to see the sql create table
rake db:rollback #rollback the previous migration

## add column
  add_column :table_name,
  :column_name, :column_type
  
## remove column
  remove_column :table_name, :column_name
```

```ruby
  rails g migration add_price_to_cars 'price:decimal{10,2}'
# generates this code:
  class AddPriceToCars < ActiveRecord::Migration
  def change
    add_column :cars, :price, :decimal, precision: 10, scale: 2
  end
end
```

* ***For begin with application with many migrations is better load the schema file (snapshot from last db state) instead run all migrations.***

```
rake db:schema:load
```

* ***rename columns:*** rename_column :table_name , :old_column_name, :new_column_name
```ruby
  rails g migration rename_make_to_company
  # is necesary add code by hand
  class RenameMakeToCompany < ActiveRecord::Migration
  def change
    rename_column :cars , :make, :company
  end
end
```

### Metaprogramming

* In dynamic language like ruby, methods don't have to be predefined - they need to only by found when invoked.
* There is another way to call methods in ruby, object.send(method/symbol, parameters..)

```ruby
class Dog
    def bark  
      puts "Woof, woof!"
    end
    def greet(greeting)
      puts greeting
    end
end
  
dog = Dog.new
dog.bark # Woof, woof!
dog.send("bark") # Woof, woof!
dog.send(:bark) # Woof, woof!
dog.send :bark # Woof, woof!
dog.send(:greet, "hola") #hola
  
```

```
rb(main):001:0> props = {name: "John", age:15 }
=> {:name=>"John", :age=>15}
irb(main):002:0> class Person; attr_accesor :name, :age; end
NoMethodError: undefined method `attr_accesor' for Person:Class
	from (irb):2:in `<class:Person>'
	from (irb):2
	from /usr/bin/irb:12:in `<main>'
irb(main):003:0> class Person; attr_accessor :name, :age; end
=> nil
irb(main):004:0> person = Person.new
=> #<Person:0x007f89ce80d7c0>
irb(main):005:0> props.each {|key,value| person.send("#{key}=", value)}
=> {:name=>"John", :age=>15}
irb(main):006:0> person
=> #<Person:0x007f89ce80d7c0 @name="John", @age=15>
```

### Advantages

* Can decide in runtime which methods to call

```ruby
###store class
class Store
def get_piano_desc
    "Excellent piano"
end
def get_piano_price
120.00
end
def get_violin_desc
    "Fantastic violin"
end
def get_violin_price
110.00
end
  # ...many other similar methods...
end

### class reporting system
require_relative 'store'

class ReportingSystem
        def initialize
                @store = Store.new
        end

def get_piano_desc
        @store.get_piano_desc
end

def get_piano_price
        @store.get_piano_price
end

  # ...many more similar methods...
end

rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" # => Excellent piano costs 120.00

## class reporting system with dynamic methods

require_relative 'store'
class ReportingSystem
        def initialize
                @store = Store.new
                @store.methods.grep(/^get_(.*)_desc/) { ReportingSystem.define_report_methods_for $1 }
        end
        def self.define_report_methods_for (item)
                define_method("get_#{item}_desc") { @store.send("get_#{item}_desc")}
                define_method("get_#{item}_price") { @store.send("get_#{item}_price")}
end end
rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" # => Excellent piano costs 120.00
```

* No more code duplicated

### Ghost methods
* When we call a method that not exists we get NoMethodError
* Ruby looks for the method invoked in the class to wich it belongs
* Then it goes up the ancestors tree (classes and modules)
* If still doesn't find the method, it call ***method_missing*** method
* Is possible override ***method_missing***
* You have access to:
 1. Name of the method called
 2. Any arguments passed in
 3. A block if it was passed
 
```ruby
class Mystery
	# no_methods defined
	def method_missing (method, *args)
		puts "Looking for..."
		puts "\"#{method}\" with params (#{args.join(',')}) ?" 
		puts "Sorry... He is on vacation..."
		yield "Ended up in method_missing" if block_given?
	end 
end
m = Mystery.new
m.solve_mystery("abc", 123123) do |answer|
puts "And the answer is: #{answer}" end
# => Looking for...
# => "solve_mystery" with params (abc,123123) ?
# => Sorry... He is on vacation...
# => And the answer is: Ended up in method_missing

```
* When we call a method that not exists we get NoMethodError

### Struct
* Generator of specific classes, each one of which is defined to hold a set of variables and their accessors (“Dynamic Methods”)

### OpenStruct
* Object (similar to Struct) whose attributes are created dynamically when first assigned (“Ghost methods”)

```ruby
Customer = Struct.new(:name, :address) do # block is optional 
	def to_s
		"#{name} lives at #{address}" end
	end
	jim = Customer.new("Jim", "-1000 Wall Street") 
	puts jim # => Jim lives at -1000 Wall Street
	
	
require 'ostruct' # => need to require ostruct for OpenStruct
some_obj = OpenStruct.new(name: "Joe", age: 15) some_obj.sure = "three"
some_obj.really = "yes, it is true" some_obj.not_only_strings = 10
puts "#{some_obj.name} #{some_obj.age} #{some_obj.really}" 
# => Joe 15 yes, it is true
```

```ruby
require_relative 'store' 
class ReportingSystem
	def initialize 
		@store = Store.new
	end
	
	def get_piano_desc
		@store.get_piano_desc 
	end
	def get_piano_price 
		@store.get_piano_price
	end
  	# ...many more simimlar methods...
end

rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" 
# => Excellent piano costs 120.00

### Can be replaced with

require_relative 'store'
class ReportingSystem 
	def initialize
		@store = Store.new 
	end
	def method_missing(name, *args)
		super unless @store.respond_to?(name) # Super to avoid recursive call with parent
		@store.send(name)
	end 
end

rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" 
# => Excellent piano costs 120.00
```

