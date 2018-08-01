# CRUD

## Create

* Select a collection on the client and call insert_one or insert_many
* insert_one: insert one document to collection
* insert_many: insert multiple documents to the collection

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

## “_id” field
* _id - primary key for every document
* default field for the BSON object and is indexed automatically
* You can add a custom “id” field if you like (but different from the default _id)

## Read

* find command
* find – returns a cursor object – allows us to iterate over the selected document(s)  Can be used with query criteria

### Projections
* Limits the fields to return from all matching documents • Canspecifyinclusionorexclusion.
* _id is automatically included by default  true or 1: inclusive
* false or 0: exclusive
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

## Paging

* Paging is accomplished with skip and limit
* skip(n)- tells mongodb that it should skip ‘n’ results
* limit(n)- instructs mongodb that it should limit the result length to ‘n’ results

## Sort controls
* sort - Specifies the order in which the query returns matching documents.
* 1 for Ascending
* -1 for Descending

```ruby

#Paging Limit
db[:zips].find.limit(3).each { |r| pp r}

#Limit and Skip
db[:zips].find.skip(3).limit(3).each { |r| pp r}

# Sorting
#ASCENDING
db[:zips].find.limit(3).sort({:city => 1 }).each { |r| pp r}

#DESCENDING
db[:zips].find.limit(3).sort({:city => -1 }).each { |r| pp r}

```

## Find

* Find controls with lt and gt operator
* lt less than
* gt greaer than

```ruby 
db[:zips].find(:city => {:$lt => 'D'}).limit(2).to_a.each
{ |r| pp r}
 1. db[:zips].find(:city => {:$lt => 'P', :$gt => 'B'}).limit(3).to_a.each
{ |r| pp r}
```

### Find By - Regex
* Regex – supports regular expression capabilities for pattern matching strings in queries.
```ruby
db[:zips].find(:city => {:$regex => 'X'}).limit(5).each
{|r| pp r}
# Will retrieve cities containing X in their names (5 documents only)
 db[:zips].find(:city => {:$regex => 'X$'}).limit(5).each {|r| pp r}
# Displays cities ending with X
 db[:zips].find(:city => {:$regex => '^X'}).projection({:_id => false}).limit(5).to_a.each {|r| pp r}
# Displays cities starting with X
 db[:zips].find(:city => {:$regex => '^[A- E]'}).projection({:_id => false}) .limit(5).to_a.each {|r| pp r}
# Displays cities that match the regex (A to E)
```

### $exists
* Will check to see of the document exists when the boolean is true
```ruby
db[:zips].find(:city => {:$exists => true}).projection({:_id => false}).limit(3).to_a.each {|r| pp r}
```

### $not
* $not performs a logical NOT operation
* Selects the documents that do not match the <operator-expression>
  
```ruby
db[:zips].find(:pop =>{'$not' => {'$gt' => 9500}}).projection ({_id:false}).limit(20).to_a.each{|r| pp r}
```
  
### $type
* $type - selects the documents where the value of the field is an instance of the specified numeric BSON type
* Handy when dealing with unstructured data where data types are not predictable

```ruby
db[:zips].find({:state=> {:$type => 2}}).first
```
## Replace
### replace_one
* replace_one – Replace a document in the collection according to the specified parameters
```ruby
db[:zips].insert_one(:_id => "100", :city => "citytemp", :loc => [ -76.05922700000001, 39.564894 ], :pop => 4678, :state => "MD" )
db[:zips].find(:_id => "100").replace_one(:_id => "100", :city => "city02", :loc => [ -78.22, 36.22 ], :pop => 2000, :state => "MD" )
db[:zips].find(:_id => "100").to_a
```


