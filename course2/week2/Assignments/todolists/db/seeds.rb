# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all

due_date = Date.today + 1.year

users_to_create = [{first_name:'Carly', last_name: 'Fiorina', birth_year: 1954, gender: 'female'},
    {first_name:'Donald', last_name: 'Trump', birth_year: 1946, gender: 'male'},
    {first_name:'Ben', last_name: 'Carson', birth_year: 1951, gender: 'male'},
    {first_name:'Hillary', last_name: 'Clinton', birth_year: 1947, gender: 'female'}
]

users_to_create.each do |user_to_create|
    user = User.create! ({username: user_to_create[:last_name], password_digest: 'password'})
    
    profile = Profile.create!(
        {
            first_name: user_to_create[:first_name], last_name: user_to_create[:last_name], 
            birth_year: user_to_create[:birth_year], gender: user_to_create[:gender]
        }
    )
    user.profile = profile 

    todo_list = TodoList.create!( {list_name: "#{user_to_create[:first_name]}_list" , list_due_date: due_date })
    
    user.todo_lists << todo_list

    5.times do
        todo_item = TodoItem.create!({due_date: due_date, title: "#{user_to_create[:first_name]}_title", 
            description: "#{user_to_create[:first_name]}_decription"})
        
        todo_list.todo_items << todo_item
    end

end
