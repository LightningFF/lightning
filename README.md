# Lightning
Short description and motivation.

## Usage
How to use my plugin.

* `bundle install`
* `bin/rails lightning:install:migrations`
* `bin/rails db:migrate SCOPE=lightning`
* Add a file under `config/initializers/lightning.rb` with the following line: `Lightning.entity_class = "User"`
* Add method for display

```ruby
  def ff_display
    self.name
  end
```

* Check feature availability for account: `Lightning::Feature.has_feature(user, 'homepage_v2')`

## Rails Console Usage
### Features
* Create Feature: `Lightning::Feature.create(<key>, <description>, <state>)` where state is one of three options: `[:inactive, :enabled_globally, :enabled_per_entity]`
* Find feature by key: `Lightning::Feature.find_by_key(<key>)`
* Update feature description: `@feature.set_description(<description>)`
* Update feature state
    - Mark inactive: `@feature.inactive!`
    - Enable globally: `@feature.enabled_globally!`
    - Enable per entity: `@feature.enabled_per_entity!`
* Delete feature: `Lightning::Feature.delete(<key>)`
### Feature Permissions/Opt Ins
* Add account to feature: `@feature.add_account(<account>)`
* List accounts for feature: `@feature.accounts`
* Check if feature is enabled for account at feature level: `@feature.enabled_for?(<account>)`
* Check if feature is enabled for account at class level: `Lightning::Feature.enabled_for?(<account>, <key>)`
* Remove account access to feature: `@feature.remove(<account>)`

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'lightning'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install lightning
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
