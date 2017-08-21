  ## name styling

variables =  nombre_variable
constantes = CONSTANT_VARIABLE
Clases y módulos = CamelCase

punto y coma no necesario, sólo si se quiere tener dos sentences en una misma linea
 ```ruby a = 1; b =2 ```

irb => es el REPL de ruby

*************************************
 ## flow control
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

imprime 10

```ruby
until

a = 9
until a >= 10
	puts a
	a += 1
end
```
imprime 9
*********************************************
 ## true/false

false and nil are false, everything else are TRUE ******* 0, 'false', '', 'nil' are true
***************************************
 ## case
two flavors

#first flavor
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

#second flavor
```ruby
name  = 'Fisher'
case name
	when /fish/i then puts "Something is fishy here"
	when 'Smith' then puts "Your name is Smith"
end
```
********************************
 ## for: 
 Almost never used, instead times/each is used
 
```ruby
for i in 0..2
	puts i
end
```
*******************************************************
 ## ===
=== is the pattern matching operator!
```ruby
=== matches regular expressions
=== checks range membership
=== checks being instance of a class
=== calls lambda expressions
=== sometimes checks equality, but mostly it does not
```
*********************************************************
 ## functions and methods
generally a function is defined outside of a class and a method is defined inside a class
in Ruby all class or method belongs at leat one class, but not always writtern inside a class
 * parens it is not necesary
 * there is not necesary the type for params
 * is possible returns everything
 * returns the last line
 * return is optional

default values for parameters
```ruby
def factorial(n = 5)
	n == 0? 1 : n * factorial(n - 1)
end
```
if for call don´t send value takes 5
**************************************************
 ## splat
```ruby
def max(prueba, *numbers, prueba1)
        numbers.max
end

 p max('hola',1,2,3,5,6,7,100,'hola1')
 ```
***************************************************
 ## blocks

portions of code, used with:

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
****************************************************
