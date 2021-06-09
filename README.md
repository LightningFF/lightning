# ⚡️ Lightning

![Tests](https://github.com/LightningFF/lightning/actions/workflows/run_test.yml/badge.svg) [![Gem Version](https://badge.fury.io/rb/lightningff.svg)](https://badge.fury.io/rb/lightningff)

Get started with feature flags in <1 minute. Works with Ruby on Rails. Control who can access features from a simple Web UI or the console. Here's the Web UI:

![2021-06-09 at 12 50 p m](https://user-images.githubusercontent.com/1835120/121349297-40036480-c921-11eb-8ccf-9bd454f54b1e.png)

![2021-06-09 at 12 49 p m](https://user-images.githubusercontent.com/1835120/121349208-25c98680-c921-11eb-9c31-53bf0a4aa5db.png)

- Enable (or disable) a feature for everyone
- Enable it for specific models in your database (you can configure which models can be feature flagged)
- Easily hide certain features behind flags
- Lightning stores data on your database so you don't have to worry about availablity (currently works only with `ActiveRecord`)

## Install

Add the following link to Gemfile
```ruby
gem 'lightningff', require: 'lightning'
```
and run `bundle install`.

#### Script Installation

Run the following script to install the entire feature flag functionality without manual setup for your models (i.e. User, Workspace)
```ruby
rails lightning:install User Workspace
```
If you want more control over the setup, run the command below and check out [Manual Installation](#manual-installation) and skip the migrations part
```ruby
rails lightning:install
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

## Usage

```ruby
user = User.create(name: 'Dummy user')

# Check if feature is enabled for entity
Lightning.enabled?(user, 'homepage_v2')

# Opt in an entity
Lightning.opt_in('homepage_v2', user)

# Opt out an entity
Lightning.opt_out('homepage_v2', user)

# List entities opted in to a feature
Lightning.opt_ins('hompage_v2')
```

## UI Setup

Mount engine in `routes.rb` file
```ruby
Rails.application.routes.draw do
  mount Lightning::Engine => "/lightning"
end
```

## API

**Create feature (state is disabled)**

```ruby
Lightning.create!('homepage_v2', 'New homepage with better logo')
```

**Find a feature by key**

```ruby
Lightning.get('homepage_v2')
```

**List all features**

```ruby
Lightning.list
```

**Update feature state/description**

```ruby
Lightning.update('homepage_v2', { state: 'enabled_per_entity', description: 'Homepage with new nav' })
```

**Delete feature**

```ruby
Lightning.delete('homepage_v2')
```

---

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
