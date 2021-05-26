module Lightning
  class Engine < ::Rails::Engine
    isolate_namespace Lightning

    initializer "lightning.assets.precompile" do |app|
      app.config.assets.precompile += %w( lightning/application.css )
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
