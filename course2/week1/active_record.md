# ActiveRecord

* In rails, the model usually uses some ORM version
Three Prerequisites:
1. ActiveRecord has to know how to find your database (when Rails is loaded, this info is read from config/database.yml file)
2. (Convention) There is a table with a plural name that corresponds to ActiveRecord::Base subclass with a singular name
3. (Convention) Expects the table to have a primary key named id
