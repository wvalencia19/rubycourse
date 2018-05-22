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

## Many-to-Many Association

* One person can have many hobbies
* One hobby can be shared by many people ✧  habtm (has_and_belongs_to_many)
* Need to create an extra (a.k.a. join) table (without a model, i.e. just a migration)

```
 Convention: Plural model names separated by an underscore in alphabetical order
 rails g model hobby name
 rails g migration create_hobbies_people person:references hobby:references
```

```ruby
class Person < ActiveRecord::Base
    has_one :personal_info, dependent: :destroy
    has_many :jobs
    has_many :my_jobs, class_name: "Job"
    has_and_belongs_to_many :hobbies
 end
 
 class Hobby < ActiveRecord::Base
    has_and_belongs_to_many :people
end

```

```
 josh = Person.find_by first_name: "Josh"
 lebron = Person.find_by first_name: "LeBron"
 programming = Hobby.create name:"Programming"
 josh.hobbies << programming
 lebron << programming
```

* Many-to-Many contains 2 models and 3 migrations
* Join table needs to only exist in the DB, but not in Ruby code

## Rich Many-to-Many association

* Sometimes, you need to keep some data on the join table or
* You need to store grandchild relationships on a model, like user ➔ articles ➔ comments
* In our case – all salary ranges for a particular person
* ActiveRecordprovidesa:throughoptionforthis purpose
* Basic idea: you first create a regular parent-child relationship and then use the child model as a “join” between the parent and grandchild

```
rails g model salary_range min_salary:float max_salary:float job:references
```

```ruby
class Job < ActiveRecord::Base
  belongs_to :person
  has_one :salary_range
end

class SalaryRange < ActiveRecord::Base
  belongs_to :job
end

class Person < ActiveRecord::Base
    has_one :personal_info, dependent: :destroy
    has_many :jobs
    has_many :my_jobs, class_name: "Job"
    has_and_belongs_to_many :hobbies

    has_many :approx_salaries, through: :jobs, source: :salary_range
end
```

```
lebron = Person.find_by(fist_name: "LeBron")
lebron.jobs.count
Job.find(12).create_salary_range(min_salary: 10000, max_salary:20000)
Job.find(13).create_salary_range(min_salary: 10000, max_salary:20000)
lebron.approx_salaries

```
## ActiveRecord Calculations

```ruby
class Person < ActiveRecord::Base
    has_one :personal_info, dependent: :destroy
    has_many :jobs
    has_many :my_jobs, class_name: "Job"
    has_and_belongs_to_many :hobbies

    has_many :approx_salaries, through: :jobs, source: :salary_range

    def max_salary
        approx_salaries.maximum(:max_salary)
    end
end
```
* Average, minimum and sum also available... (http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html)
lebron = Person.find_by last_name: "James"
lebron.max_salary

## default_scope

* Class “method” for specifying how the records are retrieved by default from the database (instead of relying on the database default)

```
irb(main):001:0> Hobby.pluck :name
   (0.5ms)  SELECT "hobbies"."name" FROM "hobbies"  ORDER BY "hobbies"."name" ASC
```

```ruby
class Hobby < ActiveRecord::Base
    has_and_belongs_to_many :people
    default_scope {order :name}
end
```

* Use unscoped to break out of the default

```irb(main):004:0> Hobby.unscoped.pluck :name
   (0.2ms)  SELECT "hobbies"."name" FROM "hobbies"
```

***scope :name, lambda***

```
class Person < ActiveRecord::Base
    has_one :personal_info, dependent: :destroy
    has_many :jobs
    has_many :my_jobs, class_name: "Job"
    has_and_belongs_to_many :hobbies

    has_many :approx_salaries, through: :jobs, source: :salary_range

    def max_salary
        approx_salaries.maximum(:max_salary)
    end

    scope :ordered_by_age, -> {order age: :desc}
    scope :starts_with, -> (starting_string){where("first_name LIKE ?", "#{starting_string}")}
end

```
* Chaining

```
Person.ordered_by_age.pluck :age
Person.ordered_by_age.starts_with("Jo") :age, :first_name

Person.ordered_by_age.limit(2).starts_with("Jo") :age, :first_name
```

* Scopes always return ActiveRecord::Relation
* Can make your ActiveRecord queries very expressive

## Active Record validations

* Preferably, you would like to have some control over what goes into the database
* Not every input might be appropriate
* If these validations fail – your information should not be saved to the database
* Active Record provides a lot of built-in validators

### :presence and :uniqueness
* presence: true
 Make sure the field contains some data
* uniqueness: true
 A check is performed to make sure no record exists in the database (already) with the given value for the specified attribute
 
 ```ruby
 
class Job < ActiveRecord::Base
  belongs_to :person
  has_one :salary_range

  validates :title, :company, presence: true
end
``` 

```
irb(main):008:0> job = Job.new
=> #<Job id: nil, title: nil, company: nil, position_id: nil, person_id: nil, created_at: nil, updated_at: nil>
irb(main):009:0> job.errors
=> #<ActiveModel::Errors:0x007f815683d298 @base=#<Job id: nil, title: nil, company: nil, position_id: nil, person_id: nil, created_at: nil, updated_at: nil>, @messages={}>
irb(main):010:0> job.save
   (0.1ms)  begin transaction
   (0.1ms)  rollback transaction
=> false
irb(main):011:0> job.errors
=> #<ActiveModel::Errors:0x007f815683d298 @base=#<Job id: nil, title: nil, company: nil, position_id: nil, person_id: nil, created_at: nil, updated_at: nil>, @messages={:title=>["can't be blank"], :company=>["can't be blank"]}>
```
### Other Common Validators

* :numericality – validates numeric input
* :length – validates value is a certain length
* :format – validates value complies with some regular expression format
* :inclusion – validates value is inside specified range
* :exclusion – validates value is out of the specified range

### Writing Your Own Validator

1.  Write a method that does some validation and calls errors.add(columnname, error)when it encounters an error condition
1. Specify it as a symbol for the validate method

```ruby
class SalaryRange < ActiveRecord::Base
  belongs_to :job

  validate :min_is_less_than_max

  def min_is_less_than_max
    if min_salary > max_salary
      errors.add(:min_salary, "Cannot be greater than maximun salary!")
    end
  end

end
```

* Validations give you control over what goes into DB
* See the guides for more information on Active Record
•  http://guides.rubyonrails.org/active_record_basics.html
•  http://guides.rubyonrails.orgactive_record_querying.html •  http://guides.rubyonrails.org/association_basics.html
•  http://guides.rubyonrails.org/active_record_callbacks.html

### N+1 Query issue
```
Person.all.each {|p| puts p.personal_info.weight} -> do a select query for each person
Person.includes(:personal_info).all.each {|p| puts p.personal_info.weight} -> do a select query for each person
```

## Transactions 
```ruby
ActiveRecord::Base.transaction do
 david.withdrawl(100)
 mary.deposit(100)
```
### Diferent active record classes in a single transaction

```ruby
Account.transaction do
 balance.save!
 account.save!
end
```

