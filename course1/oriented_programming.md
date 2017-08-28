# Object Oriented
### Classes

* Are things(car,person, etc), containers of methods(behavior)
* Objects are instances of those things
* Objects contains instance variables(state), example @color

### Instance Variables
* Begin with @
* Not declared
* Available to all instance methods of the class

* New creates an instance of class, this causes initialize(constructor)
* Objects can be (should be) initialized inside initialize method

```ruby
class Person
  def initialize (name, age) # "CONSTRUCTOR"
    @name = name
    @age = age
  end
  def get_info
    @additional_info = "Interesting"
    "Name: #{@name}, age: #{@age}"
  end
end

person1 = Person.new("Joe", 14)
p person1.instance_variables # [:@name, :@age]
puts person1.get_info # => Name: Joe, age: 14
p person1.instance_variables # [:@name, :@age, :@additional_info]
```
* Is not possible have access to instance variables directly(are private), for that is necesary create get and set methods
* For default the methods have public access
```ruby
class Person
  def initialize (name, age) # "CONSTRUCTOR"
    @name = name
    @age = age
  end
  def name
  	@name
  end
  def name= (new_name) 
  	@name = new_name 	
  end
end

person1 = Person.new("Joe", 14)
puts person1.name # Joe
person1.name = "Mike"
puts person1.name # Mike
# puts person1.age # undefined method `age' for #<Person:
```
# Exist a easier way to define get and set methods
* Use attr_* 
* attr_accessor => getter and setter
* attr_reader => getter only
* attr_writter => setter only

```ruby
class Person
  attr_accessor :name, :age # getters and setters for name and age
end

person1 = Person.new
p person1.name # => nil
person1.name = "Mike"
person1.age = 15
puts person1.name # => Mike
puts person1.age # => 15
person1.age = "fifteen"
puts person1.age # => fifteen
```

* self is necesary to call the method age=, otherwise create a local variable age

```ruby
class Person
  attr_reader :age
  attr_accessor :name

  def initialize (name, ageVar) # CONSTRUCTOR
    @name = name
    
    self.age = ageVar # call the age= method
    puts age
  end
  def age= (new_age)
    @age = new_age unless new_age > 120
  end
end

person1 = Person.new("Kim", 13) # => 13
puts "My age is #{person1.age}" # => My age is 13
person1.age = 130 # Try to change the age
puts person1.age # => 13 (The setter didn't allow the change)
```
### || Operator

* || evaluates the left side
* If true, then returns it
* Else return the right side

```ruby
@x = @x || 5
@x ||= 5 #same as above

##Example
class Person
  attr_reader :age
  attr_accessor :name

  def initialize (name, age) # CONSTRUCTOR
    @name = name
    self.age = age # call the age= method
  end
  def age= (new_age)
    @age ||= 5 # default
    @age = new_age unless new_age > 120
  end
end
person1 = Person.new("Kim", 130)
puts person1.age # => 5 (default)
person1.age = 10 # change to 10
puts person1.age # => 10
person1.age = 200 # Try to change to 200
puts person1.age # => 10 (still)
##
```
### Class methods and variables
* Invoked on the class, oppositive instance methods, similar to static methods from java
* self OUTSIDE of the method definition refers to the class object
* Three ways to define class methods
* Class varibles begin with @@
```ruby
class MathFunctions
  def self.double(var) # 1. Using self
    times_called; var * 2;
  end
  class << self # 2. Using << self
    def times_called
      @@times_called ||= 0; @@times_called += 1
    end
  end
end
def MathFunctions.triple(var) # 3. Outside of class
  times_called; var * 3
end

# No instance created!
puts MathFunctions.double 5 # => 10
puts MathFunctions.triple(3) # => 9
puts MathFunctions.times_called # => 3	
```

### Class Inheritance
* Each class implicity inherits from Object
* Object inherits from BasicObject
* Not multiple inheritance, Mixins are used instead
```ruby
class Dog
  def to_s
    "Dog"
  end
  def bark
    "barks loudly"
  end
end
class SmallDog < Dog
  def bark # Override
    "barks quietly"
  end
end

dog = Dog.new # (btw, new is a class method)
small_dog = SmallDog.new
puts "#{dog}1 #{dog.bark}" # => Dog1 barks loudly
puts "#{small_dog}2 #{small_dog.bark}" # => Dog2 barks quietly
```
### Modules
* Containers for classes, methods and constants or other modules.
* Like a class but cannot be instantiated
* Used for two purposes:
  1. Namespaces
  2. Mix-in: Shared code between diferent classes
 
```ruby
##Namespaces
module Sports
  class Match
    attr_accessor :score
  end
end

module Patterns
  class Match
    attr_accessor :complete
  end
end

match1 = Sports::Match.new
match1.score = 45; puts match1.score # => 45

match2 = Patterns::Match.new
match2.complete = true; puts match2.complete # => true


##Mix-in
module SayMyName
  attr_accessor :name
  def print_name
    puts "Name: #{@name}"
  end
end

class Person
  include SayMyName
end
class Company
  include SayMyName
end

person = Person.new
person.name = "Joe"
person.print_name # => Name: Joe
company = Company.new
company.name = "Google & Microsoft LLC"
company.print_name # => Name: Google & Microsoft LLC
```
