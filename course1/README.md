### Print

* puts(print strings to console): similar to System.out.println() in java
* p: prints internal representation of an object
*********************
### Find methods for object

"hello".methods.grep /case/
*********************
### Name styling

variables =  nombre_variable
constantes = CONSTANT_VARIABLE
Clases y módulos = CamelCase

punto y coma no necesario, sólo si se quiere tener dos sentences en una misma linea
 ```ruby a = 1; b =2 ```

irb => es el REPL de ruby

*************************************
 ### Flow control
if/elsif/else
case
ultil/unless?
while/for

while

```ruby
a = 10
while a > 9
	puts a
	a -= 1 # same as a = a-1
end
```

prints 10

```ruby
until

a = 9
until a >= 10
	puts a
	a += 1
end
```
prints 9
*********************************************
 ### true/false

false and nil are false, everything else are TRUE ******* 0, 'false', '', 'nil' are true
***************************************
 ### case
Two flavors

* First flavor
```ruby
age = 21
case
	when age >= 21
		puts "you can buy a drink"
	when 1 == 0
		puts "written by a drunk programmer"
	else
		puts "Default condition"
end
```

* Second flavor
```ruby
name  = 'Fisher'
case name
	when /fish/i then puts "Something is fishy here"
	when 'Smith' then puts "Your name is Smith"
end
```
********************************
 ### for: 
 Almost never used, instead times/each is used
 
```ruby
for i in 0..2
	puts i
end
```
*******************************************************
 ### ===
=== is the pattern matching operator!
```ruby
=== matches regular expressions
=== checks range membership
=== checks being instance of a class
=== calls lambda expressions
=== sometimes checks equality, but mostly it does not
```
*********************************************************
 ### functions and methods
Generally a function is defined outside of a class and a method is defined inside a class
in Ruby all class or method belongs at leat one class, but not always writtern inside a class
 * parens it is not necesary
 * there is not necesary the type for params
 * is possible returns everything
 * returns the last line
 * return is optional

Default values for parameters
```ruby
def factorial(n = 5)
	n == 0? 1 : n * factorial(n - 1)
end
```
if for call don´t send value takes 5
**************************************************
 ### splat
```ruby
def max(prueba, *numbers, prueba1)
        numbers.max
end

 p max('hola',1,2,3,5,6,7,100,'hola1')
 ```
***************************************************
 ### Blocks

Portions of code, used with:

{}  -> better when is a single line
do end  -> better when multiple lines

is possible send parameters, example |index|

```ruby
1.times {puts 'Hello world!'}

2.times do |index| 
	if index > 0
		puts index
	end
end
#shows 1

2.times {|index| puts index if index > 0}
```

* Is possible pass blocks into methods:

1. Implicit
```ruby
def two_times_implicit
	return "Not block" unless block_given?
	yield # to call block
	yield # to call block
end

two_times_implicit { print "Hello"} # => Hello
				    # => Hello
two_times_implicit # => No block				      
```
2. Explict
```ruby
def two_times_implicit(&i_am_a_block) # & for identify block
	return "Not block" if i_am_a_block.nil?
	i_am_a_block.call # to call block
	i_am_a_block.call # to call block
end

two_times_implicit { print "Hello"} # => Hello
				    # => Hello
two_times_implicit # => No block
```
****************************************************
### Files

* Read file
text.txt
```
The first linea of the file
```
```ruby
File.foreach('text.txt') do |line|
	puts line        # => The first linea of the file
	p line.          # => "The first linea of the file\n"
	p line.chomp #remove \n character  # => "The first linea of the file"
	p line.split #line to array  # => ["The", "first", "linea", "of", "the", "file"]
end
```

with exception control

```ruby
begin
	File.foreach('text.txt') do |line|
		puts line        # => The first linea of the file
		p line.          # => "The first linea of the file\n"
		p line.chomp #remove \n character  # => "The first linea of the file"
		p line.split #line to array  # => ["The", "first", "linea", "of", "the", "file"]
	end
rescue Exception => e
	puts e.message
	puts "Let's pretend this didn't happend .."
end
```

Alternative

```ruby
if File.exists? 'text.txt'
	File.foreach('text.txt') do |line|
		puts line        # => The first linea of the file
		p line.          # => "The first linea of the file\n"
		p line.chomp #remove \n character  # => "The first linea of the file"
		p line.split #line to array  # => ["The", "first", "linea", "of", "the", "file"]
	end
end
```
* Write file
```ruby
	File.open("text1.txt","w") do |file|
		file.puts "linea 1" 
		file.puts "linea 2"
	end
```
*****************************************
### Enviroment Variables
```ruby
	puts ENV['EDITOR']
```
***********************
# Strings
1. Single quote '' : 
* Very literal
* Allow scaping of ' with \
* Prints almost everything else as is
2. Double quote "" :
* Interpret special characters like \n
* Permit interpolation

### Interpolation
```ruby
def multiply(one, two)
	"#{one} multiplied by #{two} is equals #{one * two}"
end

puts multiply(3,5) # => 3 multiplied by 5 is equals 15
```
```ruby
my_name = " tim"
puts my_name.lstrip.capitalize # => Tim
p my_name # => " tim" #because returns a copy of my_name
puts my_name.lstrip! #(!)saves remove for the space
my_name[0] = 'K' # replaces te fitst character
puts my_name = Kim

cur_weather = #Q{It's a hot day outside
		 Grab your umbrellas...
		}
cur_weather.lines do |line|
	line.sub! 'hot', 'rainy' #substitute 'hot' with 'rainy'
	puts "#{line.strip}"
end
# => It's a raint day outside
# => Grab your umbrellas...
```
### Symbols
Highly optimized strings
* Constant names that you don't have to pre-declarate
* Cadena que representa algo
* Does not matter the exactly string, if is uppercase or lowercase
```ruby
:foo
```
************
# Arrays

* Collection of object references (auto expandable), don't have specific limit
* Indexed using [] operator(method)
* Can be indexed with negative numbers or ranges
* Heterogeneous types
* Can use %w{str1 str2} for string array creation

```ruby
het_arr = [1, "two", :three] 
puts het_arr[1] # => two (array indices starts at 0)
arr_words = %w{ what a day great today! }
puts arr_words[-2]  # => great
puts "#{arr_words.first} - #{arr_words.last}" => what - today!
p arr_words[-3,2] # => ["day","great"] (go back 3 and take 2)
p arr_words[2..4] # => ["day", "great", "today!"] (range)
puts arr_words.join(',') # => what,a,day,great,today! (make a string separated by ',')
```
### Modify arrays

* Append: push or <<
* Remove: pop(remove the last) or shift(remove the first)
* Set: [] (method)
* Randomly pull element(s) out: sample
* Sort: sort! (order minor to max)
* Reverse: reverse! (inverse order)

```ruby
#You want a stack LIFO?
stack = []; stack << "one", stack.push("two")
puts stack.pop # => two

#You want a stack FIFO?
stack = []; stack.push("one"), stack.push("two")
puts stack.shift # => one

a = [5,3,4,2].sort!.reverse!
p a # => [5,4,3,2]
p a.sample(2) 
a[6] = 33 # => [5,4,3,2,nil,nil,33]
```

### Other methods
* each: iterator for array, receive block
* select: filter array by selecting
* reject: filter array by rejecting
* map: modify each element in the array and returns one new

```ruby
a = [1,3,4,7,8,10]
a.each {|num| print num} # => 1347810 (no new line)
new_arr = a.select { |num| num > 4}
p new_arr # => [7, 8, 10]
new_arr = a.select { |num| num < 10}
	  .reject { |num| num.even?} #rechace los pares
p new_arr # => [1, 3, 7]

new_arr = a.map { |x| x * 3 }
p new_arr # => [3, 9, 12, 21, 24, 30]
```
# Ranges

Express natural consecutive secuences

* 1..20
* a..z

* (..) includes all numbers
* (...) doesn't not include the last number
* Efficient: only store the start and end
* Can be converted to an array with to_a
* Used for conditions and intervals

```ruby
some_range = 1..3
some_range.max # => 3
some_range.include? 2 # => true
puts (1..10) === 5.3 # => true
puts ('a'...'r') === 'r' # false
p ('k'..'z').to_a.sample(2) # => ["m", "o"] (random)

age = 55
case age
	when 0..12 then puts "Still a baby"
	when 13..99 then puths "Teenager at heart!"
	else puts "you are older.."
end
# => Teenager at heart!

```

# Hashes

* Indexed  collections of object references
* Created with {} or Hash.new
* Also know like associative arrays
* Index (key) can be anything, not only integer, can be string, symbols, etc

### Accesed
Using the [] operator
### Set
Using
* => for creation
* [] for post-creation

```ruby
#doesn't is a block is a hash
editor_props = {"font" => "Arial", "size" => 12, "color" => "red"}
editor_props1 = {font: "Arial", size: 12, color:"red"}
puts editor_props.length # => 3
puts editor_props["font"] # => Arial
puts editor_props1[:font] # => Arial
editor_props["background"] = "Blue"

editor_props.each_pair do |key,value|
	puts "Key: #{key} Value: #{value}"
end

```
* If call the hash with a key that doesn't exists returns nil
* Is possible set a default value with Hash.new(0) returns 0 for previous case

```ruby
word_frecuency = Hash.new(0)

sentence = 'Chicka chicka boom boom'
sentence.split.each do |word|
	word_frecuency[word.downcase] += 1
end
p word_frecuency # => {"chicka"=>2, "boom"=>2}
```
### In Ruby 1.9

* The order the putting things into hash maintained
* If use symbols as keys:   key: 'value'
* If hash is the last argument to a method {} are optional

```ruby
family_tree_19 = {oldest: 'Jim', older: 'Joe', younger: 'Jack'}
family_tree_19[:youngest] = 'Jeremy'
p family_tree_19 # => {:oldest=>"Jim", :older=>"Joe", :younger=>"Jack", :youngest=>"Jeremy"}

def adjust_colors(props = {foreground: 'red', background: 'white'})
    puts "Foreground: #{props[:foreground]}" if props[:foreground]
    puts "Background: #{props[:background]}" if props[:background]
end

adjust_colors # => Foreground: red
	      # => Background: white
	 
#Different ways to send params
adjust_colors({foreground: 'green'}) # => Foreground: green
adjust_colors background: 'yella' # => Background: yella
adjust_colors :background => 'magneta' # => Background: magneta
```

### Block and Hash Confusion

```ruby
# Let's say you have a Hash
a_hash = { :one => "one" }

# Then, you output it
puts a_hash # => {:one=>"one"}

# If you try to do it in one step - you get a SyntaxError
# puts { :one => "one" }

# RUBY GETS CONFUSED AND THINKS {} IS A BLOCK!!!

# To get around this - you can use parens
puts ({ :one => "one" }) # => {:one=>"one"}

# Or drop the {} altogether...
puts one: "one"# => {:one=>"one"}
```

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
