require 'rails_helper'

describe Lightning::Api do
  context '.create' do
    it 'creates the feature' do
      Lightning::Api.create!('create_feature', 'New feature for testing')
      expect(Lightning::Api.get('create_feature')).to be_an_instance_of Lightning::Feature
    end

    it 'fails to create features with duplicate keys' do
      key = 'create_feature'
      Lightning::Api.create!(key, 'New feature for testing')
      expect { Lightning::Api.create!(key, 'New feature for testing') }.to raise_error(Lightning::Api::FeatureError)
    end
  end

  context '.get' do
    it 'retrieve feature that does not exist' do
      expect { Lightning::Api.get('feature_that_does_not_exist') }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end

    it 'retrieve existing feature' do
      feature_key = 'new_feature'
      created_feature = Lightning::Api.create!(feature_key, 'New feature for testing')
      retrieved_feature = Lightning::Api.get(feature_key)
      expect(retrieved_feature).to eq(created_feature)
    end
  end
end
