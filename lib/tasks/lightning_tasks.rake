desc "Setup script for the gem"
namespace :lightning do
  task :install do
    _, *args = ARGV

    puts '️⚡️ Copying migrations ...'
    `bin/rails lightning:install:migrations`

    puts '⚡️ Running migrations ...'
    `bin/rails db:migrate SCOPE=lightning`

    puts '⚡️ Creating lightning initializers'
    `echo "Lightning.flaggable_entities = [#{args.map{ |a| '\"' + a + '\"'}.join(", ")}]" > config/initializers/lightning.rb`

    args.each do |model|
      puts 'Adding taggable to model: ' + model
      Dir.glob("app/models/**/#{model.underscore}.rb").each do |f|
        puts f

        # Find the model name and add the line underneath it
        file = File.open(f)
        new_file_contents = StringIO.open
        add_line_here = false
        file.each do |line|
          if add_line_here
            new_file_contents << "  include Lightning::Flaggable\n"
            add_line_here = false
          end

          if line.include?('class') && line.include?(model) && line.include?(' < ')
            add_line_here = true
          end
          new_file_contents << line
        end
        file.close

        # Update file contents with new file contents
        new_file_contents.seek 0
        File.open(f, 'wb').write new_file_contents.read
      end
    end

    puts '⚡️ Lightning setup complete'
    exit
  end
end
