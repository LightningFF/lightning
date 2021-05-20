require 'rails_helper'

RSpec.describe Lightning::Feature, type: :model do
  it "can be successfully created" do
    feature = Lightning::Feature.create("Don", "Feature description",:enabled_globally)
    expect(feature).to eq(true)
  end
end
