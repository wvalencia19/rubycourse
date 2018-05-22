# Advance query

## db/seeds.rb

* Rails provides db/seeds.rb for precisely this purpose
* To populate the database with some initial values – just run

```
rake db:seed
```

```ruby
Person.destroy_all

Person.create! [
{first_name: "Kalman", last_name: "Smith", age: 33},
{first_name: "Wilson", last_name: "Valencia", age: 33}
]
```

* db/seeds.rb lets you seed the database
* Use create! - otherwise it will fail silently

## Exact Searches

We already know about basic retrieves: 

1. find(id) or find(id1, id2)
1. find_by(hash)
1. where(hash)

* Can specify SQL fragment (as opposed to hash) inside the where and find_by

```sql
Person.where("age BETWEEN 30 AND 33").to_a
Person.find_by("first_name LIKE '%man'")
```

Very powerful, but beware of ***SQL injection!***

* Manipulating raw SQL to hack into a database
* This includes maliciously dropping/deleting tables or gaining access to confidential information
* https://en.wikipedia.org/wiki/SQL_injection

## Array Condition Syntax
* Lets you specify SQL fragment with ? followed by values (parameters)
* “Automagically” performs conversions on the input values and escapes strings in the SQL
* Immune to SQL injection
* Similar to a PreparedStatement in Java

```sql
Person.where("age BETWEEN ? AND ?", 28, 34).to_a
Person.find_by("first_name LIKE ? OR last_name LIKE ?", '%J%', '%J%').to_a
```

* Array Condition Syntax is “SQL Injection safe” and easy to use, but there are now two (small) problems:
1. You have to keep track of the order of parameters “hiding” behind the “?”
1. If you have n “?” – you need to pass in n values, even if they are a reference to the same value

## Hash Condition Syntax

 Instead of “?”, you specify symbols which map to the values in the hash passed in as a second parameter
 
```sql
Person.where("age BETWEEN :min_age AND :max_age", min_age:28, max_age:34).to_a
Person.find_by("first_name LIKE :pattern OR last_name LIKE :pattern", pattern: '%J%').to_a
```

* Always use either the Array or Hash Condition Syntax to avoid SQL injection
* Hash syntax seems more intuitive to most people

## Relational aspect of RDBMS

***Relationships***
* ActiveRecord is pretty awesome so far, but what about the relational aspect of the database?

* The individual Ruby models map pretty well to individual tables in the database, but how easy is it to maintain database relations and build on them?

## One-to-One Association

* One person has exactly one personal_info entry
* One personal_info entry belongs to exactly one person
* The “belongs to” side is the one with a foreign key

```
Convention: Default name for the foreign key is {master_table_singular}
_id, e.g. person_id

rails g model personal_info height:float weight:float person:references
```

```ruby
#person.rb

class Person < ActiveRecord::Base
    has_one :personal_info
end

#personal_info.rb
class PersonalInfo < ActiveRecord::Base
  belongs_to :person
end
```

```
bill= Person.find_by fist_name: "Bill"
pi1 = PersonalInfo.create height: 6.5, weight: 220
bill.personal_info = pi1
```

* In addition, you now also have build_personal_info(hash) and create_personal_info(hash) methods on a person instance
* create_personal_info creates a record in the DB right away, while build_personal_info does not
* Both remove the previous reference in the DB

```
bill = Person.find_ last_name: "Gates"
bill.personal_info
bill.buidl_personal_info height: 6.5, weight: 220
bill.save


josh = Person.find_ first_name: "Josh"
josh.create_personal_info height: 6.5, weight: 220
```

* has_one / belongs_to (and integer column in DB) is all you need to establish a One-to-One association
* ActiveRecord tries enforcing a One-to-One in the DB!

## One-to-Many Association

* One person has one or more jobs
* One job entry belongs to exactly one person
* The “belongs to” side is the one with a foreign key

```
Convention: Default name for the foreign key is {master_table_singular}_id, e.g. person_id
rails g model job title company position_id person:references 
```

```ruby
#person.rb
class Person < ActiveRecord::Base
    has_one :personal_info
    has_many :jobs
end

#job.rb
class Job < ActiveRecord::Base
  belongs_to :person
end
```

```
Job.create company:"MS", title: "Developer", position_id:"#1234"
p1 = Person.first
p1.jobs << Job.first
```

1. person.jobs = jobs
* Replaces existing jobs with a new array
* As opposed to person.jobs << job(s) where the jobs are appended
1. person.jobs.clear
* Disassociates jobs from this person by setting the foreign key to NULL
1. create and where methods for jobs become scoped to the person!

## Scoped Jobs: Where

```
Person.first.jobs.where(company: "MS").count
```

## Options for has_many - :class_name

```
class_name: ‘Modelname’
```

```ruby
class Person < ActiveRecord::Base
    has_one :personal_info
    has_many :jobs
    has_many :my_jobs, class_name: "Job"
end
```

## dependent

* has_many, has_one and belongs_to
support :dependent option which lets you specify the fate of the association when the parent gets destroyed
1. :delete – remove associated object(s)
1. :destroy – same as above, but remove the
association by calling destroy on it
1. :nullify – set the FK to NULL (leave the associated entity alone – just disassociate)

```ruby
class Person < ActiveRecord::Base
    has_one :personal_info, dependent: :destroy
    has_many :jobs
    has_many :my_jobs, class_name: "Job"
end
```
