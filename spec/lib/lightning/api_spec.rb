# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lightning do
  let(:user) { User.create(name: 'Dummy User') }
  let(:user2) { User.create(name: 'Dummy User') }
  let(:workspace) { Workspace.create(name: 'Dummy workspace') }

  describe '.create' do
    it 'creates the feature' do
      described_class.create!('create_feature', 'New feature for testing')
      expect(described_class.get('create_feature')).to be_an_instance_of(Lightning::Feature)
    end

    it 'fails to create features with duplicate keys' do
      key = 'create_feature'
      described_class.create!(key, 'New feature for testing')
      expect { described_class.create!(key, 'New feature for testing') }
        .to raise_error(::Lightning::Errors::FailedToCreate)
    end
  end

  describe '.get' do
    it 'throws an error when feature does not exist' do
      expect { described_class.get('feature_that_does_not_exist') }
        .to raise_error(::Lightning::Errors::FeatureNotFound)
    end

    it 'retrieves existing feature' do
      feature_key = 'new_feature'
      created_feature = described_class.create!(feature_key, 'New feature for testing')
      retrieved_feature = described_class.get(feature_key)
      expect(retrieved_feature).to eq(created_feature)
    end
  end

  describe '.list' do
    it 'returns an empty list when no features exist' do
      expect(described_class.list).to be_empty
    end

    it 'list all features with some results' do
      [1, 2, 3].each { |k| described_class.create!(k, "Feature #{k}") }

      expect(described_class.list.count).to eq(3)
    end
  end

  describe '.update' do
    it 'update key for feature' do
      old_key = 'old_key'
      new_key = 'new_key'
      described_class.create!(old_key, 'Old key')
      described_class.update(old_key, {key: new_key})
      expect { described_class.get(old_key) }.to raise_error(::Lightning::Errors::FeatureNotFound)
      expect(described_class.get(new_key)).not_to be_nil
    end

    it 'update description for feature' do
      new_description = 'New description'
      key = 'update_description_key'
      described_class.create!(key, 'Old description')
      described_class.update(key, {description: new_description})
      expect(described_class.get(key).description).to eq(new_description)
    end

    it 'update state for feature' do
      key = 'update_state_key'
      described_class.create!(key, 'description')
      described_class.update(key, { state: 'disabled' })
      expect(described_class.get(key).state).to eq('disabled')
      described_class.update(key, {state: 'enabled_globally'})
      expect(described_class.get(key).state).to eq('enabled_globally')
    end

    it 'update feature state to invalid value throws error' do
      key = 'update_state_key'
      described_class.create!(key, 'description')
      expect { described_class.update(key, { state: 'random' }) }.to raise_error(::Lightning::Errors::InvalidFeatureState)
    end

    it 'update feature that does not exist throws error' do
      expect { described_class.update('feature_does_not_exist', {description: 'Description'}) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  describe '.delete' do
    it 'feature that does exist' do
      delete_feature_key = 'delete_feature'
      described_class.create!(delete_feature_key, 'Feature to be deleted')
      described_class.delete(delete_feature_key)
      expect { described_class.get(delete_feature_key) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end

    it 'feature that does not exist throws error' do
      expect { described_class.delete('feature_does_not_exist') }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  describe '.opt_ins' do
    it 'feature with no entities' do
      key = 'no_entities_key'
      described_class.create!(key, 'Feature with no entities')
      expect(described_class.opt_ins(key)).to be_empty
    end

    it 'feature that does not exist throws error' do
      expect { described_class.opt_ins('feature_does_not_exist') }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  describe '.opt_in' do
    it 'feature adds a new entity' do
      key = 'feature-key'
      described_class.create!(key)
      described_class.opt_in(key, user)
      expect(described_class.opt_ins(key).count).to eq(1)
    end

    it 'feature adds an existing entity is noop' do
      key = 'feature_key'
      described_class.create!(key)
      described_class.opt_in(key, user)
      described_class.opt_in(key, user)
      expect(described_class.opt_ins(key).count).to eq(1)
    end

    it 'feature adds two entities with same entity type different entity id' do
      key = 'feature_key'
      described_class.create!(key)
      described_class.opt_in(key, user)
      described_class.opt_in(key, user2)
      expect(described_class.opt_ins(key).count).to eq(2)
    end

    it 'feature adds two entities with same id different entity type' do
      key = 'feature_key'
      described_class.create!(key)
      described_class.opt_in(key, user)
      described_class.opt_in(key, workspace)
      expect(described_class.opt_ins(key).count).to eq(2)
    end

    it 'feature that does not exist throws error' do
      expect { described_class.opt_in('feature_does_not_exist', user) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  describe '.opt_out' do
    it 'feature removes already existing entity' do
      key = 'enable_entity'
      described_class.create!(key)
      described_class.opt_in(key, user)
      described_class.opt_out(key, user)
      expect(described_class.opt_ins(key)).to be_empty
    end

    it 'feature remove non-existing entity noop' do
      key = 'enable_entity'
      described_class.create!(key)
      described_class.opt_out(key, user)
      expect(described_class.opt_ins(key)).to be_empty
    end

    it 'feature that does not exist throws error' do
      expect { described_class.opt_out('feature_does_not_exist', user) }.to raise_error(::Lightning::Errors::FeatureNotFound)
    end
  end

  describe '.enabled?' do
    let(:feature_key) { 'feature-key' }

    before do
      described_class.create!(key)
    end

    subject { described_class.enabled?(key, user) }

    context "when key exists" do
      it 'returns true when enabled for user entity' do
        described_class.update(key, { state: :enabled_per_entity })
        described_class.opt_in(key, user)
        expect(subject).to eq(true)
      end

      it 'returns false when not enabled for user entity' do
        described_class.update(key, { state: :enabled_per_entity })
        expect(subject).to eq(false)
      end

      it 'returns true when enabled globally' do
        described_class.update(key, { state: :enabled_globally })
        expect(subject).to eq(true)
      end

      it 'returns false when disabled' do
        described_class.update(key, { state: :disabled })
        expect(subject).to eq(false)
      end
    end

    context "when key does not exist" do
      let(:feature_key) { 'feature-key-non-existent' }

      it 'returns false when feature does not exist' do
        expect(subject).to eq(false)
      end
    end
  end
end
