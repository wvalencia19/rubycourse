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
### Enumerable Module
* You can include in your own class
* Provide map, select, reject, etc methods
* Used by array class and other class
* Provide an implementation for each method
```ruby
# name of file - player.rb
class Player

  attr_reader :name, :age, :skill_level

  def initialize (name, age, skill_level)
    @name = name
    @age = age
    @skill_level = skill_level
  end

  def to_s
    "<#{name}: #{skill_level}(SL), #{age}(AGE)>"
  end

end

# team.rb
class Team
  include Enumerable # LOTS of functionality

  attr_accessor :name, :players
  def initialize (name)
    @name = name
    @players = []
  end
  def add_players (*players) # splat
    @players += players
  end
  def to_s
    "#{@name} team: #{@players.join(", ")}"
  end
  def each
    @players.each { |player| yield player }
  end
end

require_relative 'player'
require_relative 'team'

player1 = Player.new("Bob", 13, 5); player2 = Player.new("Jim", 15, 4.5)
player3 = Player.new("Mike", 21, 5) ; player4 = Player.new("Joe", 14, 5)
player5 = Player.new("Scott", 16, 3)

red_team = Team.new("Red")
red_team.add_players(player1, player2, player3, player4, player5) # (splat)

# select only players between 14 and 20 and reject any player below 4.5 skill-level
elig_players = red_team.select {|player| (14..20) === player.age }
                       .reject {|player| player.skill_level < 4.5}
puts elig_players # => <Jim: 4.5(SL), 15(AGE)>
                                  # => <Joe: 5(SL), 14(AGE)>
```
### Variables Scope
* Methods and class begin new scope
* Use **local_variables** to see which variables are in the actual scope

```ruby
v1 = "outside"

class MyClass
  def my_method
        # p v1 EXCEPTION THROWN - no such variable exists
    v1 = "inside"
    p v1
    p local_variables
  end
end

p v1 # => outside
obj = MyClass.new
obj.my_method # => inside
              # => [:v1]
p local_variables # => [:v1, :obj]
p self # => main
```
### Constants Scope
* Rules are different than variables
* Inside scope can see outside scope, can override outer constants
* Outside constant keep the original value.

```ruby
module Test
  PI = 3.14
  class Test2
    def what_is_pi
      puts PI
    end
  end
end
Test::Test2.new.what_is_pi # => 3.14

module MyModule
  MyConstant = 'Outer Constant'
  class MyClass
    puts MyConstant # => Outer Constant
    MyConstant = 'Inner Constant'
    puts MyConstant # => Inner Constant
  end
  puts MyConstant # => Outer Constant
end
```
### Blocks scope
* Blocks are different than methods, takes the outer scope.

```ruby
class BankAccount
  attr_accessor :id, :amount
  def initialize(id, amount)
    @id = id
    @amount = amount
  end
end

acct1 = BankAccount.new(123, 200)
acct2 = BankAccount.new(321, 100)
acct3 = BankAccount.new(421, -100)
accts = [acct1, acct2, acct3]

total_sum = 0
accts.each do |eachAcct|
  total_sum += eachAcct.amount
end

puts total_sum # => 200
```
* One variable created inside block is only avialable to the block
* Params with the same name than outer variable are always local
* Can explicity declare block local variables after semicolon(;) in the block parameter lists

```ruby
arr = [5, 4, 1]
cur_number = 10
arr.each do |cur_number|
  some_var = 10 # NOT available outside the block
  print cur_number.to_s + " " # => 5 4 1
end
puts # print a blank line
puts cur_number # => 10

adjustment = 5
arr.each do |cur_number;adjustment|
  adjustment = 10
  print "#{cur_number + adjustment} " # => 15 14 11
end
puts
puts adjustment # => 5 (Not affected by the block)
```
### Access Control
* Three levels for access control
 1. Public
 2. Protected
 3. Private
 
 ```ruby
 class Car
  def initialize(speed, comfort)
    @rating = speed * comfort
  end

  # Can't SET rating from outside
  def rating
    @rating
  end
end

puts Car.new(4, 5).rating # => 20
 ```
 
 * Two ways to specify access control:
  1. Specify public, protected or private: everything until the next access control key will be that control access.
  2. List the methods for access control type. Example: private :method1, :method2
   
```ruby
  class MyAlgorithm
  private
    def test1
      "Private"
    end
  protected
    def test2
      "Protected"
    end
  public
    def public_again
      "Public"
    end
end

class Another
  def test1
    "Private, as declated later on"
  end
  private :test1
end
```
 
* By default, all mehtod have public access control
* protected: can be invoked by the objects of the definig class or its subclasses
* private: can't be invoked with an explicit receiver. Exception: Setting attribute.

```ruby
class Person
  def initialize(age)
        self.age = age # LEGAL - EXCEPTION
        puts my_age
        # puts self.my_age # ILLEGAL
                           # CANNOT USE self or any other receiver
  end

  private
    def my_age
        @age
    end
    def age=(age)
      @age = age
    end
end

Person.new(25) # => 25
```
