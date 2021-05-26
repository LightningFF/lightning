# ⚡️ Lightning ![Tests](https://github.com/LightningFF/lightning/actions/workflows/run_test.yml/badge.svg) [![Gem Version](https://badge.fury.io/rb/lightningff.svg)](https://badge.fury.io/rb/lightningff)
An end-to-end feature flagging system that can be setup in <1 minute.

Lightning is a rails gem you can install into your Rails application to get both console and UI access to manage feature flags. Lightning saves you time to avoid building an in-house solution. 

## Install

Add the following link to Gemfile
```ruby
gem 'lightningff', require: 'lightning'
```
and run `bundle install`. _Note: You might need to run `bundle update` to resolve any incompatible issues with rails._

Set up feature flag migrations by running the following lines
```bash
bin/rails lightning:install:migrations
bin/rails db:migrate SCOPE=lightning
```

Create `config/initializers/lightning.rb` and set your flaggable entities
```ruby
Lightning.flaggable_entities = ["User", "Workspace"]
```
For each flaggable model, add `include Lightning::Flaggable`.
```ruby
class User < ApplicationRecord
  include Lightning::Flaggable
end
```

To check feature availability for entity: `Lightning::Feature.enabled?(user, <feature_key>)`

### UI setup

Mount engine in `routes.rb` file
```ruby
Rails.application.routes.draw do
  mount Lightning::Engine => "/lightning"
end
```

_Note: If you encounter an AssetNotPrecompiled error when accessing the UI, try one of the following_
* Add `//= link lightning/application.css` to `app/assets/config/manifest.js`
* Add `config.assets.check_precompiled_asset = false` to your `development.rb` (or other environment file) 

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
bin/rails db:create
bin/rails db:migrate
bin/rails server
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
