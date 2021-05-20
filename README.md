# ⚡️ Lightning
Set up an end-to-end feature flagging system in <1 minute.

## Getting Started
How to use my plugin.

* Add gem to your application's Gemfile: `gem 'lightning'`
* `bundle install`
* `bin/rails lightning:install:migrations`
* `bin/rails db:migrate SCOPE=lightning`
* Create the file `config/initializers/lightning.rb` and populate it with your flaggable entities (i.e. `Lightning.flaggable_entities = ["User", "Workspace"]`)
* Include the following module for each flaggable model: `include Lightning::Flaggable`. Example below
```ruby
class User < ApplicationRecord
  include Lightning::Flaggable
end
```
* Check feature availability for entity: `Lightning::Feature.enabled_for?(user, 'homepage_v2')`
* To manage feature flags through the UI, add the following to your applications routes.rb file where `"lightning"` can be any route you define:`mount Lightning::Engine => "/lightning"`

## Functionality
* Easy-to-use UI that allows creating, modifying, and deleting features and permissioning entities to those features
* Highly configurable options to display data on the UI
* Console API to manage features and permissions without any UI


## Rails Console API
### Feature Management
* Create Feature: `Lightning::Feature.create(<key>, <description>, <state>)` where state is one of three options: `[:inactive, :enabled_globally, :enabled_per_entity]`
* Find feature by key: `Lightning::Feature.find_by_key(<key>)`
* Update feature description: `@feature.set_description(<description>)`
* Update feature state
    - Mark inactive: `@feature.inactive!`
    - Enable globally: `@feature.enabled_globally!`
    - Enable per entity: `@feature.enabled_per_entity!`
* Delete feature: `Lightning::Feature.delete(<key>)`
### Feature Permissions/Opt Ins Management
* Add entity to feature: `@feature.add_entity(<entity>)`
* List entities for feature: `@feature.entities`
* Check if feature is enabled for entity at feature level: `@feature.enabled_for?(<entity>)`
* Check if feature is enabled for entity at class level: `Lightning::Feature.enabled_for?(<entity>, <key>)`
* Remove entity access to feature: `@feature.remove(<entity>)`

## Advanced Configuration

Lightning makes is super easy to configure how data is represented through the UI. 

## Running Tests

To run the test suite, pull the repo locally and run `rspec spec/`. All tests live in the **spec/** folder.


## Contributing

You need to have ruby version 2.7.3 installed locally and rails version 6.1.3. 

```ruby
cd test/dummy
bundle install
bin/rails db:migrate
bin/rails server
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
