require 'rails_helper'

RSpec.describe Lightning::Api, type: :model do
  it "feature can be successfully created" do
    feature = Lightning::Api.create("Don", "Feature description",:enabled_globally)
    expect(feature).to eq(true)
  end
end
