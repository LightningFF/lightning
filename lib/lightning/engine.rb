module Lightning
  class Engine < ::Rails::Engine
    isolate_namespace Lightning

    initializer "lightning.assets.precompile" do |app|
      app.config.assets.precompile += %w( lightning/application.css lightning/favicon )
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
