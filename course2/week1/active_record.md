# ActiveRecord

* In rails, the model usually uses some ORM version
Three Prerequisites:
1. ActiveRecord has to know how to find your database (when Rails is loaded, this info is read from config/database.yml file)
2. (Convention) There is a table with a plural name that corresponds to ActiveRecord::Base subclass with a singular name
3. (Convention) Expects the table to have a primary key named id

```
Car.column_names
Car.primary_key
```
# CRUD

### Insert
* Three ways to create a record in the database
 1. Use an empty constructor and (ghost) attributes to set the values and then call save
 2. Pass a hash of attributes into the constructor and then call save
 3. Use create method with a hash to create an object and save it to the database in one step
 
 ```
 ####### first way
 irb(main):001:0> p1 = Person.new; p1.first_name = 'Joe'; p1.last_name = 'Smith'
=> "Smith"
irb(main):002:0> p1.save
   (0.2ms)  begin transaction
  SQL (2.0ms)  INSERT INTO "people" ("first_name", "last_name", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["first_name", "Joe"], ["last_name", "Smith"], ["created_at", "2017-09-14 04:12:00.278674"], ["updated_at", "2017-09-14 04:12:00.278674"]]
   (0.9ms)  commit transaction
 
 ###### second way
 
 p2 = Person.new(first_name: "John", last_name: "Doe"); p2.save
   (0.1ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "people" ("first_name", "last_name", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["first_name", "John"], ["last_name", "Doe"], ["created_at", "2017-09-14 04:14:26.742075"], ["updated_at", "2017-09-14 04:14:26.742075"]]
   (2.4ms)  commit transaction
   
##### Thrid way
irb(main):004:0> Person.create(first_name: "Jane", last_name: "Doe")
   (0.1ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "people" ("first_name", "last_name", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["first_name", "Jane"], ["last_name", "Doe"], ["created_at", "2017-09-14 04:15:22.573259"], ["updated_at", "2017-09-14 04:15:22.573259"]]
   (2.4ms)  commit transaction
=> #<Person id: 3, first_name: "Jane", last_name: "Doe", created_at: "2017-09-14 04:15:22", updated_at: "2017-09-14 04:15:22">

 ```
 
 ### Retrieve
 
* find(id) or find(id1, id2)
* Throws a RecordNotFound exception if not found    first, last, take, all
* Return the results you expect or nil if nothing is found    order(:column) or order(column: :desc)
* Allows ordering of the results. Ascending or descending    pluck
* Allows to narrow down which fields are coming back •  Need to call at the end!

```
irb(main):006:0> Person.all.order(first_name: :desc)
  Person Load (0.4ms)  SELECT "people".* FROM "people"  ORDER BY "people"."first_name" DESC
=> #<ActiveRecord::Relation [#<Person id: 2, first_name: "John", last_name: "Doe", created_at: "2017-09-14 04:14:26", updated_at: "2017-09-14 04:14:26">, #<Person id: 1, first_name: "Joe", last_name: "Smith", created_at: "2017-09-14 04:12:00", updated_at: "2017-09-14 04:12:00">, #<Person id: 3, first_name: "Jane", last_name: "Doe", created_at: "2017-09-14 04:15:22", updated_at: "2017-09-14 04:15:22">]>
irb(main):007:0> Person.all.order(first_name: :desc).to_a
  Person Load (0.3ms)  SELECT "people".* FROM "people"  ORDER BY "people"."first_name" DESC
=> [#<Person id: 2, first_name: "John", last_name: "Doe", created_at: "2017-09-14 04:14:26", updated_at: "2017-09-14 04:14:26">, #<Person id: 1, first_name: "Joe", last_name: "Smith", created_at: "2017-09-14 04:12:00", updated_at: "2017-09-14 04:12:00">, #<Person id: 3, first_name: "Jane", last_name: "Doe", created_at: "2017-09-14 04:15:22", updated_at: "2017-09-14 04:15:22">]
irb(main):008:0> Person.first
  Person Load (0.3ms)  SELECT  "people".* FROM "people"  ORDER BY "people"."id" ASC LIMIT 1
=> #<Person id: 1, first_name: "Joe", last_name: "Smith", created_at: "2017-09-14 04:12:00", updated_at: "2017-09-14 04:12:00">
irb(main):009:0> Person.all.first
  Person Load (0.3ms)  SELECT  "people".* FROM "people"  ORDER BY "people"."id" ASC LIMIT 1
=> #<Person id: 1, first_name: "Joe", last_name: "Smith", created_at: "2017-09-14 04:12:00", updated_at: "2017-09-14 04:12:00">
irb(main):010:0> Person.all[0] #bad performance, get all registers from database and after takes the first
  Person Load (0.3ms)  SELECT "people".* FROM "people"
=> #<Person id: 1, first_name: "Joe", last_name: "Smith", created_at: "2017-09-14 04:12:00", updated_at: "2017-09-14 04:12:00">
irb(main):011:0> Person.take # get one record regardless of the order
  Person Load (0.2ms)  SELECT  "people".* FROM "people" LIMIT 1
=> #<Person id: 1, first_name: "Joe", last_name: "Smith", created_at: "2017-09-14 04:12:00", updated_at: "2017-09-14 04:12:00">
irb(main):012:0> Person.take 2 # get two records regardless of the order
  Person Load (0.2ms)  SELECT  "people".* FROM "people" LIMIT 2
=> [#<Person id: 1, first_name: "Joe", last_name: "Smith", created_at: "2017-09-14 04:12:00", updated_at: "2017-09-14 04:12:00">, #<Person id: 2, first_name: "John", last_name: "Doe", created_at: "2017-09-14 04:14:26", updated_at: "2017-09-14 04:14:26">]
irb(main):013:0> Person.all.map {|person|person.first_name} #bad performance, get all registers from database
  Person Load (0.3ms)  SELECT "people".* FROM "people"
=> ["Joe", "John", "Jane"]
irb(main):014:0> Person.pluck(:first_name) #returns array with column first_name values
   (0.3ms)  SELECT "people"."first_name" FROM "people"
=> ["Joe", "John", "Jane"]
```

### Pluck 

pluck can be used to query multiple or several of the underlying table of a model. Accepts a list of column names as an argument and returns an array of values for the specified columns with the corresponding data type.

* ***Where***

```
Person.where(last_name: "Doe")
  Person Load (0.3ms)  SELECT "people".* FROM "people" WHERE "people"."last_name" = ?  [["last_name", "Doe"]]
=> #<ActiveRecord::Relation [#<Person id: 2, first_name: "John", last_name: "Doe", created_at: "2017-09-14 04:14:26", updated_at: "2017-09-14 04:14:26">, #<Person id: 3, first_name: "Jane", last_name: "Doe", created_at: "2017-09-14 04:15:22", updated_at: "2017-09-14 04:15:22">]>
irb(main):038:0> Person.where(last_name: "Doe").first
  Person Load (0.3ms)  SELECT  "people".* FROM "people" WHERE "people"."last_name" = ?  ORDER BY "people"."id" ASC LIMIT 1  [["last_name", "Doe"]]
=> #<Person id: 2, first_name: "John", last_name: "Doe", created_at: "2017-09-14 04:14:26", updated_at: "2017-09-14 04:14:26">
irb(main):039:0> Person.where(last_name: "Doe")[0] # Bad performance
  Person Load (0.2ms)  SELECT "people".* FROM "people" WHERE "people"."last_name" = ?  [["last_name", "Doe"]]
=> #<Person id: 2, first_name: "John", last_name: "Doe", created_at: "2017-09-14 04:14:26", updated_at: "2017-09-14 04:14:26">

Person.where(last_name:"Doe").pluck(:first_name)
   (0.2ms)  SELECT "people"."first_name" FROM "people" WHERE "people"."last_name" = ?  [["last_name", "Doe"]]
=> ["John", "Jane"]
```

* ***Find by***

* find_by(conditions_hash): Same as where, but returns a single result or nil if a record with the specified conditions is not found

* find_by!(conditions_hash): Same as find_by, but throws an exception if cannot find the result

```
Person.where(last_name:"Doe").pluck(:first_name)
   (0.2ms)  SELECT "people"."first_name" FROM "people" WHERE "people"."last_name" = ?  [["last_name", "Doe"]]
=> ["John", "Jane"]
irb(main):052:0> Person.find_by(last_name: "Doe")
  Person Load (0.3ms)  SELECT  "people".* FROM "people" WHERE "people"."last_name" = ? LIMIT 1  [["last_name", "Doe"]]
=> #<Person id: 2, first_name: "John", last_name: "Doe", created_at: "2017-09-14 04:14:26", updated_at: "2017-09-14 04:14:26">
irb(main):053:0> Person.find_by(last_name: "Doe1")
  Person Load (0.2ms)  SELECT  "people".* FROM "people" WHERE "people"."last_name" = ? LIMIT 1  [["last_name", "Doe1"]]
=> nil
irb(main):054:0> Person.find_by!(last_name: "Doe1")
  Person Load (0.2ms)  SELECT  "people".* FROM "people" WHERE "people"."last_name" = ? LIMIT 1  [["last_name", "Doe1"]]
ActiveRecord::RecordNotFound: Couldn't find Person
```

* ***limit/offset***

* limit(n): Enables you to limit how many records come back
* offset(n): Don’t start from the beginning; skip a few 
* You can combine these two to “page” through large collections of records in your database.

```
irb(main):066:0> Person.count
   (0.2ms)  SELECT COUNT(*) FROM "people"
=> 3
irb(main):067:0> Person.all.map {|person| "#{person.first_name} #{person.last_name}"}
  Person Load (0.3ms)  SELECT "people".* FROM "people"
=> ["Joe Smith", "John Doe", "Jane Doe"]
irb(main):068:0> Person.offset(1).limit(1).map {|person| "#{person.first_name} #{person.last_name}"}
  Person Load (0.4ms)  SELECT  "people".* FROM "people" LIMIT 1 OFFSET 1
=> ["John Doe"]
irb(main):069:0> Person.offset(1).limit(1).all.map {|person| "#{person.first_name} #{person.last_name}"}
  Person Load (0.2ms)  SELECT  "people".* FROM "people" LIMIT 1 OFFSET 1
=> ["John Doe"]
```

### Update

* Two ways to update a record in the database:
1.  Retrieve a record, modify the values and then call save
2.  Retrieve a record and then call update method passing in a hash of attributes with new values

* There is alsou pdate_all for batch updates •  You can chain this to the end of where

```
jane = Person.find_by first_name: "Jane"
  Person Load (0.3ms)  SELECT  "people".* FROM "people" WHERE "people"."first_name" = ? LIMIT 1  [["first_name", "Jane"]]
=> #<Person id: 3, first_name: "Jane", last_name: "Doe", created_at: "2017-09-14 04:15:22", updated_at: "2017-09-14 04:15:22">
irb(main):002:0> jane.last_name = "valencia"
=> "valencia"
irb(main):003:0> jane.save
   (0.2ms)  begin transaction
  SQL (1.0ms)  UPDATE "people" SET "last_name" = ?, "updated_at" = ? WHERE "people"."id" = ?  [["last_name", "valencia"], ["updated_at", "2017-09-15 05:03:35.989111"], ["id", 3]]
   (1.2ms)  commit transaction
=> true
irb(main):004:0> jane = Person.find(3)
  Person Load (0.3ms)  SELECT  "people".* FROM "people" WHERE "people"."id" = ? LIMIT 1  [["id", 3]]
=> #<Person id: 3, first_name: "Jane", last_name: "valencia", created_at: "2017-09-14 04:15:22", updated_at: "2017-09-15 05:03:35">

Person.find_by_last_name("Smith").update(last_name: "Smithson")
  Person Load (0.3ms)  SELECT  "people".* FROM "people" WHERE "people"."last_name" = ? LIMIT 1  [["last_name", "Smith"]]
   (0.1ms)  begin transaction
  SQL (0.3ms)  UPDATE "people" SET "last_name" = ?, "updated_at" = ? WHERE "people"."id" = ?  [["last_name", "Smithson"], ["updated_at", "2017-09-15 05:05:18.062734"], ["id", 1]]
   (2.2ms)  commit transaction
```

### Delete

```
   destroy(id) or destroy
•  Removes a particular instance from the DB
•  Instantiates an object first and performs callbacks before removing
•  Seehttp://guides.rubyonrails.org/active_record_callbacks.html    delete(id)
•  Removes the row from DB    There is also a delete_all
```
