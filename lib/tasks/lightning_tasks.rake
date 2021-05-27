desc "Setup script for the gem"
task :lightning do
  # Task goes here
  puts 'Copying migrations from engines...'
  `bin/rails lightning:install:migrations`
  puts 'Running engine migrations...'
  `bin/rails db:migrate SCOPE=lightning`
  puts 'Creating initializers script'
  `echo "Lightning.flaggable_entities = []" > config/initializers/lightning.rb`
  puts 'Successfully ran setup script'
end
