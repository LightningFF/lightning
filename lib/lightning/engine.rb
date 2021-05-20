module Lightning
  class Engine < ::Rails::Engine
    isolate_namespace Lightning

    config.generators do |g|
      g.test_framework :rspec
    end

  end
end
