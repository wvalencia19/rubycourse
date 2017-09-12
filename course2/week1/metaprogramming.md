
### Metaprogramming

* In dynamic language like ruby, methods don't have to be predefined - they need to only by found when invoked.
* There is another way to call methods in ruby, object.send(method/symbol, parameters..)

```ruby
class Dog
    def bark  
      puts "Woof, woof!"
    end
    def greet(greeting)
      puts greeting
    end
end
  
dog = Dog.new
dog.bark # Woof, woof!
dog.send("bark") # Woof, woof!
dog.send(:bark) # Woof, woof!
dog.send :bark # Woof, woof!
dog.send(:greet, "hola") #hola
  
```

```
rb(main):001:0> props = {name: "John", age:15 }
=> {:name=>"John", :age=>15}
irb(main):002:0> class Person; attr_accesor :name, :age; end
NoMethodError: undefined method `attr_accesor' for Person:Class
	from (irb):2:in `<class:Person>'
	from (irb):2
	from /usr/bin/irb:12:in `<main>'
irb(main):003:0> class Person; attr_accessor :name, :age; end
=> nil
irb(main):004:0> person = Person.new
=> #<Person:0x007f89ce80d7c0>
irb(main):005:0> props.each {|key,value| person.send("#{key}=", value)}
=> {:name=>"John", :age=>15}
irb(main):006:0> person
=> #<Person:0x007f89ce80d7c0 @name="John", @age=15>
```

### Advantages

* Can decide in runtime which methods to call

```ruby
###store class
class Store
def get_piano_desc
    "Excellent piano"
end
def get_piano_price
120.00
end
def get_violin_desc
    "Fantastic violin"
end
def get_violin_price
110.00
end
  # ...many other similar methods...
end

### class reporting system
require_relative 'store'

class ReportingSystem
        def initialize
                @store = Store.new
        end

def get_piano_desc
        @store.get_piano_desc
end

def get_piano_price
        @store.get_piano_price
end

  # ...many more similar methods...
end

rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" # => Excellent piano costs 120.00

## class reporting system with dynamic methods

require_relative 'store'
class ReportingSystem
        def initialize
                @store = Store.new
                @store.methods.grep(/^get_(.*)_desc/) { ReportingSystem.define_report_methods_for $1 }
        end
        def self.define_report_methods_for (item)
                define_method("get_#{item}_desc") { @store.send("get_#{item}_desc")}
                define_method("get_#{item}_price") { @store.send("get_#{item}_price")}
end end
rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" # => Excellent piano costs 120.00
```

* No more code duplicated

### Ghost methods
* When we call a method that not exists we get NoMethodError
* Ruby looks for the method invoked in the class to wich it belongs
* Then it goes up the ancestors tree (classes and modules)
* If still doesn't find the method, it call ***method_missing*** method
* Is possible override ***method_missing***
* You have access to:
 1. Name of the method called
 2. Any arguments passed in
 3. A block if it was passed
 
```ruby
class Mystery
	# no_methods defined
	def method_missing (method, *args)
		puts "Looking for..."
		puts "\"#{method}\" with params (#{args.join(',')}) ?" 
		puts "Sorry... He is on vacation..."
		yield "Ended up in method_missing" if block_given?
	end 
end
m = Mystery.new
m.solve_mystery("abc", 123123) do |answer|
puts "And the answer is: #{answer}" end
# => Looking for...
# => "solve_mystery" with params (abc,123123) ?
# => Sorry... He is on vacation...
# => And the answer is: Ended up in method_missing

```
* When we call a method that not exists we get NoMethodError

### Struct
* Generator of specific classes, each one of which is defined to hold a set of variables and their accessors (“Dynamic Methods”)

### OpenStruct
* Object (similar to Struct) whose attributes are created dynamically when first assigned (“Ghost methods”)

```ruby
Customer = Struct.new(:name, :address) do # block is optional 
	def to_s
		"#{name} lives at #{address}" end
	end
	jim = Customer.new("Jim", "-1000 Wall Street") 
	puts jim # => Jim lives at -1000 Wall Street
	
	
require 'ostruct' # => need to require ostruct for OpenStruct
some_obj = OpenStruct.new(name: "Joe", age: 15) some_obj.sure = "three"
some_obj.really = "yes, it is true" some_obj.not_only_strings = 10
puts "#{some_obj.name} #{some_obj.age} #{some_obj.really}" 
# => Joe 15 yes, it is true
```

```ruby
require_relative 'store' 
class ReportingSystem
	def initialize 
		@store = Store.new
	end
	
	def get_piano_desc
		@store.get_piano_desc 
	end
	def get_piano_price 
		@store.get_piano_price
	end
  	# ...many more simimlar methods...
end

rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" 
# => Excellent piano costs 120.00

### Can be replaced with

require_relative 'store'
class ReportingSystem 
	def initialize
		@store = Store.new 
	end
	def method_missing(name, *args)
		super unless @store.respond_to?(name) # Super to avoid recursive call with parent
		@store.send(name)
	end 
end

rs = ReportingSystem.new
puts "#{rs.get_piano_desc} costs #{rs.get_piano_price.to_s.ljust(6, '0')}" 
# => Excellent piano costs 120.00
```
