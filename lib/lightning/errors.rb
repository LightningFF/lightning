module Lightning::Errors
  class FeatureNotFound < StandardError; end

  class InvalidFeatureState < StandardError; end

  class EntityNotFound < StandardError; end

  class FailedToCreate < StandardError; end
end
