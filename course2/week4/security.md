# Authentication

## What Happened To The Users?
* The books/notes stuff is working pretty nicely, but everybody can see and modify everybody else’s books and notes?
* We need the two security ‘A’s:
  1. Authentication: Do we know who the user is and are his credentials valid?
  1. Authorization: Provide access only to the books/notes a particular logged-in user is authorized to modify/see
  
## Authentication Summary

**has_secure_password** to the rescue!

1. Enable (uncomment) bcrypt-ruby (Gemfile)
  * Run $bundle (install)
1. Make sure password_digest is table column
1. Account for password (not password_digest) inside strong parameters list in the controller if you plan to use mass assignment when creating users
1. No need for password column in the table (virtual attribute)

## has_secure_password

Add has_secure_password on model

```ruby
  class Reviewer < ActiveRecord::Base
    has_secure_password
    has_many :books
  end
```

## How works?

```
rails c
Running via Spring preloader in process 5228
Loading development environment (Rails 4.2.8)
irb(main):001:0> Reviewer.column_names
=> ["id", "name", "password_digest", "created_at", "updated_at"]
irb(main):002:0> Reviewer.create! name: "Joe", password: "abc123"
   (0.1ms)  begin transaction
  SQL (3.3ms)  INSERT INTO "reviewers" ("name", "password_digest", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "Joe"], ["password_digest", "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThPAiH7jAb3c2"], ["created_at", "2018-07-19 19:36:16.756483"], ["updated_at", "2018-07-19 19:36:16.756483"]]
   (2.0ms)  commit transaction
=> #<Reviewer id: 1, name: "Joe", password_digest: "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThP...", created_at: "2018-07-19 19:36:16", updated_at: "2018-07-19 19:36:16">
irb(main):003:0> joe = Reviewer.find_by_name "Jose"
  Reviewer Load (0.3ms)  SELECT  "reviewers".* FROM "reviewers" WHERE "reviewers"."name" = ? LIMIT 1  [["name", "Jose"]]
=> nil
irb(main):004:0> joe = Reviewer.find_by_name "Joe"
  Reviewer Load (0.4ms)  SELECT  "reviewers".* FROM "reviewers" WHERE "reviewers"."name" = ? LIMIT 1  [["name", "Joe"]]
=> #<Reviewer id: 1, name: "Joe", password_digest: "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThP...", created_at: "2018-07-19 19:36:16", updated_at: "2018-07-19 19:36:16">
irb(main):005:0> joe.authenticate("dsfsf")
=> false
irb(main):006:0> joe.authenticate("abc123")
=> #<Reviewer id: 1, name: "Joe", password_digest: "$2a$10$p4/xwyqAHFIf5m3hjr81tOLY0l05KfarH/8ykYw5ThP...", created_at: "2018-07-19 19:36:16", updated_at: "2018-07-19 19:36:16">
```
