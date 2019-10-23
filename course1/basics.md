### Print

* puts(print strings to console): similar to System.out.println() in java
* p: prints internal representation of an object
*********************
### Find methods for object

"hello".methods.grep /case/
*********************
### Name styling

* variables =  nombre_variable
* constantes = CONSTANT_VARIABLE
* Clases y módulos = CamelCase

punto y coma no necesario, sólo si se quiere tener dos sentences en una misma linea

 ```ruby a = 1; b =2 ```

irb => es el REPL de ruby

*************************************
 ### Flow control
* if/elsif/else
* case
* ultil/unless?
* while/for

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

false and nil are false, everything else are TRUE ******* -> 0, 'false', '', 'nil' are true
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

### * Operator
    
 Here, the list from which the new array gets constructed contains one item: the object array. That object hasn’t been mined for its inner elements, as it was in the example with the star.
 One implication is that you can use the star in front of a method argument to turn it from an array into a list. You do this in cases where you have objects in an array that you need to send to a method that’s expecting a broken-out list of arguments:
    
```   
    def combine_names(first_name, last_name)
      first_name + " " + last_name
    End
    
    names = ["David", "Black"]
    puts combine_names(*names)
    
   ```
 
 If you don’t use the unarraying star, you’ll send just one argument—an array—to the method, and the method won’t be happy.

