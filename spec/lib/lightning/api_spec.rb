require 'rails_helper'

describe Lightning::Api do

  dummy_user = User.create(name: 'Dummy User')

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
    it 'retrieve feature that does not exist throws error' do
      expect { Lightning::Api.get('feature_that_does_not_exist') }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end

    it 'retrieve existing feature' do
      feature_key = 'new_feature'
      created_feature = Lightning::Api.create!(feature_key, 'New feature for testing')
      retrieved_feature = Lightning::Api.get(feature_key)
      expect(retrieved_feature).to eq(created_feature)
    end
  end

  context '.list' do
    it 'list all features with no results' do
      expect(Lightning::Api.list).to be_empty
    end

    it 'list all features with some results' do
      [1,2,3].each { |k| Lightning::Api.create!(k, "Feature #{k}") }
      expect(Lightning::Api.list.count).to eq(3)
    end
  end

  context '.update' do
    it 'update key for feature' do
      old_key = 'old_key'
      new_key = 'new_key'
      Lightning::Api.create!(old_key, 'Old key')
      Lightning::Api.update(old_key, {key: new_key})
      expect { Lightning::Api.get(old_key) }.to raise_error(::Lightning::Errors::FeatureNotFound)
      expect(Lightning::Api.get(new_key)).not_to be_nil
    end

    it 'update description for feature' do
      new_description = 'New description'
      key = 'update_description_key'
      Lightning::Api.create!(key, 'Old description')
      Lightning::Api.update(key, {description: new_description})
      expect(Lightning::Api.get(key).description).to eq(new_description)
    end

    it 'update state for feature' do
      key = 'update_state_key'
      Lightning::Api.create!(key, 'description')
      Lightning::Api.update(key, {state: 'disabled'})
      expect(Lightning::Api.get(key).state).to eq('disabled')
      Lightning::Api.update(key, {state: 'enabled_globally'})
      expect(Lightning::Api.get(key).state).to eq('enabled_globally')
    end

    it 'update feature state to invalid value throws error' do
      key = 'update_state_key'
      Lightning::Api.create!(key, 'description')
      expect { Lightning::Api.update(key, {state: 'random'}) }.to raise_error(::Lightning::Errors::InvalidFeatureState)
    end

    it 'update feature that does not exist throws error' do
      expect { Lightning::Api.update('feature_does_not_exist', {description: 'Description'}) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  context '.delete' do
    it 'feature that does exist' do
      delete_feature_key = 'delete_feature'
      Lightning::Api.create!(delete_feature_key, 'Feature to be deleted')
      Lightning::Api.delete(delete_feature_key)
      expect { Lightning::Api.get(delete_feature_key) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end

    it 'feature that does not exist throws error' do
      expect { Lightning::Api.delete('feature_does_not_exist') }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  context '.entities' do
    it 'feature with no entities' do
      key = 'no_entities_key'
      Lightning::Api.create!(key, 'Feature with no entities')
      expect(Lightning::Api.entities(key)).to be_empty
    end

    it 'feature that does not exist throws error' do
      expect { Lightning::Api.entities('feature_does_not_exist') }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  context '.enable_entity' do
    it 'feature adds a new entity' do
      key = 'enable_entity'
      Lightning::Api.create!(key)
      Lightning::Api.enable_entity(key, dummy_user)
      expect(Lightning::Api.entities(key).count).to eq(1)
    end

    it 'feature adds an existing entity shows duplicate' do
      key = 'enable_entity'
      Lightning::Api.create!(key)
      Lightning::Api.enable_entity(key, dummy_user)
      Lightning::Api.enable_entity(key, dummy_user)
      expect(Lightning::Api.entities(key).count).to eq(2)
    end

    it 'feature that does not exist throws error' do
      expect { Lightning::Api.enable_entity('feature_does_not_exist', dummy_user) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  context '.remove_entity' do
    it 'feature removes already existing entity' do
      key = 'enable_entity'
      Lightning::Api.create!(key)
      Lightning::Api.enable_entity(key, dummy_user)
      Lightning::Api.remove_entity(key, dummy_user)
      expect(Lightning::Api.entities(key)).to be_empty
    end

    it 'feature remove non-existing entity noop' do
      key = 'enable_entity'
      Lightning::Api.create!(key)
      Lightning::Api.remove_entity(key, dummy_user)
      expect(Lightning::Api.entities(key)).to be_empty
    end

    it 'feature that does not exist throws error' do
      expect { Lightning::Api.remove_entity('feature_does_not_exist', dummy_user) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end

  end

  context '.enabled' do

    it 'enabled per entity feature is enabled for user' do
      key = 'enabled per entity'
      Lightning::Api.create!(key)
      Lightning::Api.update(key, {state: :enabled_per_entity})
      Lightning::Api.enable_entity(key, dummy_user)
      expect(Lightning::Api.enabled?(dummy_user, key)).to be true
    end

    it 'enabled per entity feature is not enabled for user' do
      key = 'enabled per entity'
      Lightning::Api.create!(key)
      Lightning::Api.update(key, {state: :enabled_per_entity})
      expect(Lightning::Api.enabled?(dummy_user, key)).to be false
    end

    it 'global feature is enabled' do
      key = 'global'
      Lightning::Api.create!(key)
      Lightning::Api.update(key, {state: :enabled_globally})
      expect(Lightning::Api.enabled?(dummy_user, key)).to be true
    end

    it 'disabled feature is not enabled' do
      key = 'disabled'
      Lightning::Api.create!(key)
      Lightning::Api.update(key, {state: :disabled})
      expect(Lightning::Api.enabled?(dummy_user, key)).to be false
    end

    it 'feature that does not exist is disabled' do
      expect(Lightning::Api.enabled?(dummy_user, 'feature_does_not_exist')).to be false
    end
  end

end
