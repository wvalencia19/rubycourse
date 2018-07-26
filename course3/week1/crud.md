# CRUD

## Create

```ruby
#disable logging
require 'mongo'; Mongo::Logger.logger.level = ::Logger::INFO

#get a connection
db = Mongo::Client.new('mongodb://localhost:27017')

#use test
db=db.use('test')

#insert_one
db[:zips].insert_one(:_id => "100",:city => "city01",:loc => [ -76.05922700000001, 39.564894],:pop => 4678,:state => "MD")

#find count (for insert_one)
db[:zips].find(:city => "city01").count

#insert_many
db[:zips].insert_many([ 
{ :_id => "200", :city => "city02",:loc => [ -74.05922700000001, 37.564894 ],:pop => 2000, :state => "CA" },
{ :_id => "201", :city => "city03",:loc => [ -75.05922700000001,35.564894 ], 
  :pop => 3000, :state => "CA" }
])
``` 

## Read

```ruby

#find by example 
db[:zips].find(:city => "BALTIMORE")

#find first
db[:zips].find.first
db[:zips].find(:state => "MD").first

#distinct
db[:zips].find.distinct(:state)

#find by (hash) - passing parameters
db[:zips].find(:city => "GERMANTOWN").count
db[:zips].find(:city => "GERMANTOWN").first

require 'pp'

pp db[:zips].find(:city => "GERMANTOWN", :state => "NY").first
pp db[:zips].find(:city => "GERMANTOWN", :state => "MD").first

#cursor iterations
db[:zips].find().each { |r| puts r }

db[:zips].find().each { |r| pp r }

#PROJECTIONS - 
db[:zips].find({:state => "MD"}).projection(state:true, _id:false).first
```
