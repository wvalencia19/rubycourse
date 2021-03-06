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

* for
```ruby
the_count = [1, 2, 3, 4, 5]

# this first kind of for-loop goes through a list
# in a more traditional style found in other languages
for number in the_count
  puts "This is count #{number}"
end

for i in 0..5
   puts "Value of local variable is #{i}"
end
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
