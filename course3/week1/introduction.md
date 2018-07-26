# Introduction

## Why RDBMS
* Relational Databases – popular and commonly used
* Initially designed for non distributed
* Low Cost RDBMS alternatives (PostgreSQL, MySQL, SQLLite )
* Very Transactional - across tables and commands, and can even be transactional across distributed resources (XA) -- at a cost
* Supports Joins -- across multiple tables allowing for normalized forms of data to be stored once
* Explosion in data
* Object/Relational Impedance mismatch
  1. Objects are constantly being moved in/out of tables/rows
* RDBMS normalization and joins are powerful, but add
up in cost
  1. Complex objects stored across many tables and rows can be expensive to handle
* “Big” data handling with better performance
* Supports unstructured data
  1. Unique data type extensions can be easily integrated into existing collections
* Operational issues (scale, performance and availability)
* Stands for “Not Only SQL”
* No Fixed Schema
* Non-relational data storage systems
   1. redis
   1. MongoDB
   1. Couchbase
   1. Cassandra
   1. Hbase
   
## Categories of NoSQL – Key/Value
* Value can be String or JSON
* Key-value hash
* Solutions
  1. Dynamo 
  1. Redis
  1. Memcached
  

| HTTP Method        | Named Routes           |
| ------------- |---------------|
| GET     | books_path | 
| GET     | {"Name": "Godfather","Genre": "Drama","Actor": "Robert DeNiro", "Director": "Francis Ford Coppola"}    |  

## Categories of NoSQL – Document

* Stores documents based up of tagged elements
* Persistent and query-able
* Solutions
 1. MongoDB
 1. CouchDB
 
|   | 
| ------------- |
| {"Name": "Godfather","Genre": "Drama","Actor": "Robert DeNiro", "Director": "Francis Ford Coppola"}    | 

## Categories of NoSQL – Column
* Uses flat structure, but with keys stored in columns rather than rows:
* Solutions
 1. Cassandra
 1. Hbase
 
| HTTP Method        | Named Routes           | Parameters  | Controller Action|
| ------------- |---------------| ------| ---------------- |
| Name     | The Godfather | The Departed| Titanic | 
| Actor     | Leonardo DiCaprio     |   Al Pacino | Leonardo DiCaprio | 
| Director | Francis Ford Coppola      |   Martin Scorsese  | James Cameron | 

## NoSQL – Not supported
* Joins are not supported
  1. Embedded documents or in middle tier code
* ACID Transactions
  1. Supported at a document level only
 
## NoSQL vs RDBMS – How to pick?
* Nature of data
  1. Row/column(structured)–RDBMS
  1. Unstructured, complex (geo-spatial or engineering data) which needs nesting - NoSQL
* Schema
  1. Static–RDBMS,Dynamic–NoSQL
* Self contained – NoSQL, Joins – RDBMS
* Flexibility of query
  1. RDBMSJoinsallowforflexibility
  1. NoSQL - Duplication of data, implement joins in middle- ware
  
## What is MongoDB
* Created by 10gen (term coined from humongous)  Definition:
  1. MongoDB is an open source, document-oriented database designed with both scalability and developer agility in mind
* Storage: JSON-like documents and “schemaless”  Well suited for Object Oriented programming
* Stores data in BSON format (Binary JSON)
* Binary form for representing simple data structures and associative arrays

## Document Store (Mapping)

|RDBMS       | MongoDB          |
| ------------- |---------------|
| Database     | Database | 
| Table, View     |   Collection |  
| Row     | JSON Document | 
| Column     |   Field |  
| Index     | Index | 
| Join    |   Embedded Document / Linking across Document |  
| Foreign Key     | Reference | 
| Partition Key     |   Shard |  


## Sample Query – SQL vs. Mongo

|RDBMS       | MongoDB          |
| ------------- |---------------|
| CREATE TABLE movies( movieId int NOT NULL AUTO_INCREMENT, name VARCHAR(30), rating VARCHAR(6), PRIMARY KEY (movieId ) )     | db.movies.insert({ "id": 10,"name": "Titanic","rating": "R" }) | 
| SELECT * FROM movies    |   db.movies.find() |  
| UPDATE movies SET rating = "NR" WHERE movieId = 101     | db.movies.update( {"id": 101 }, { $set: { rating: "NR" } } ) | 
| DELETE FROM movies WHERE rating = "R"     |   db.movies.remove( { "rating": "R" }) |


## MongoDB Basics
* Import dataset
  1. Downloadsamplezips.jsonfilefromMongoDB • Savetheabovefile
  1. Run the import command as in
* mongoimport --db test --collection zips --drop --file zips.json

## Database, Documents and Collections
* Mongo can create database on the fly • No need to create database beforehand
* Documents
  1. UnitofstoringdatainaMongoDBdatabase • JSONdocument
* Collection (similar to tables in DB)
  1. UnitofstoringdatainaMongoDBdatabase • Collection of documents
 
## Collection Types
* Capped Collection
  1. Fixed-size collections that support high-throughput operations
  1. Insertandretrievedocumentsbasedoninsertionorder
  1. Once a collection fills its allocated space, it makes room for new documents by overwriting the oldest documents in the collection
  1. db.createCollection("log", { capped : true, size : 5242880, max : 5000 } )
  
## Mongo Basics
* Start mongo shell 
  ``` 
   $ mongo
  ```
* Switch to test database 
  ```
  > use test
  ```
* Test the data with a simple find command (note: we will cover this in more depth later)
```
db.zips.findOne()
```
  1. The above command will return a single document from the zips collection.
