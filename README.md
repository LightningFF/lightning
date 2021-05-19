# Lightning
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
* Check feature availability for account: `Lightning::Feature.enabled_for?(user, 'homepage_v2')`
* To manage feature flags through the UI, add the following to your applications routes.rb file where `"lightning"` can be any route you define:`mount Lightning::Engine => "/lightning"`

## Functionality
* Easy-to-use UI that allows creating, modifying, and deleting features and permissioning accounts to those features
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
* Add account to feature: `@feature.add_account(<account>)`
* List accounts for feature: `@feature.accounts`
* Check if feature is enabled for account at feature level: `@feature.enabled_for?(<account>)`
* Check if feature is enabled for account at class level: `Lightning::Feature.enabled_for?(<account>, <key>)`
* Remove account access to feature: `@feature.remove(<account>)`

## Advanced Configuration

Lightning makes is super easy to configure how data is represented through the UI. 

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
