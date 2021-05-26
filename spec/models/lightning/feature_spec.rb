require 'rails_helper'

RSpec.describe Lightning::Feature do
  describe ".enabled?" do
    subject { feature.enabled? }

    context "when feature is disabled" do
      let(:feature) { described_class.create(key: 'test-feature') }
      it { is_expected.to eq(false) }
    end

    context "when feature is enabled" do
      let(:feature) { described_class.create(key: 'test-feature', state: :enabled_globally) }
      it { is_expected.to eq(true) }
    end
  end
end