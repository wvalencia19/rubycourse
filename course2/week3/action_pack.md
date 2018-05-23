# Action Pack

Action pack is the combinaition between ActionController + ActionView

```
rails new my_blog
rails g scaffold post tittle context:text
rake db:migrate
```

## Scaffolding creates: 
1. Migration
1. Model 
1. Routes
1. RestfulController
1. Views
1. More...

ActionPack: Routes, RestfulController, Views

## ActionView: ERB

* HTML file with an .erb extension
* ERb is a templating library (similar to JSP) that lets you embed Ruby into your html
* Two tag patterns to learn:
* <% ...ruby code... %> - evaluate Ruby code
* <%= ...ruby code... %> - output evaluated Ruby code

***And of course, there are many view helpers that assist in code creation, like link_to...***

## Action Controller
* Ruby class containing one or more actions
* Each action is responsible for responding to a request to perform some task
* Unless otherwise stated – when an action is finished firing (or even if the action is not physically present) it renders a view with the same name as the action
* The action always needs to be mapped in routes.rb
 


