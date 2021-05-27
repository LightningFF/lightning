# ⚡️ Lightning ![Tests](https://github.com/LightningFF/lightning/actions/workflows/run_test.yml/badge.svg) [![Gem Version](https://badge.fury.io/rb/lightningff.svg)](https://badge.fury.io/rb/lightningff)
An end-to-end feature flagging system that can be setup in <1 minute.

Lightning is a rails gem you can install into your Rails application to get both console and UI access to manage feature flags. Lightning saves you time to avoid building an in-house solution. 

## Install

Add the following link to Gemfile
```ruby
gem 'lightningff', require: 'lightning'
```
and run `bundle install`. _Note: You might need to run `bundle update` to resolve any incompatible issues with rails._

#### Script Installation
Run the following script to install the entire feature flag functionality without manual setup for your models (i.e. User, Workspace)
```ruby
rake lightning:install User Workspace
```
If you want more control over the setup, run the command below and check out [Manual Installation](#manual-installation) and skip the migrations part
```ruby
rake lightning:install
```


#### Manual Installation
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

### UI setup

Mount engine in `routes.rb` file
```ruby
Rails.application.routes.draw do
  mount Lightning::Engine => "/lightning"
end
```

## Rails Console API Usage

```ruby
### Feature Management
# Create feature (state is disabled)
Lightning.create!('homepage_v2', 'New homepage with better logo')
# Get feature by key
Lightning.get('homepage_v2')
# List all features
Lightning.list
# Update feature state/description
Lightning.update('homepage_v2', {state: 'enabled_per_entity', description: 'Homepage with new nav'})
# Delete feature
Lightning.delete('homepage_v2')

### Feature Permissions Management
u = User.create(name: 'Dummy user')
# Check if feature is enabled for entity
Lightning.enabled?(u, 'homepage_v2')
# Add entity to feature
Lightning.enable_entity('homepage_v2', u)
# List entities for feature
Lightning.entities
# Remove entity to feature
Lightning.remove_entity('homepage_v2', u)
```

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
