require 'spec_helper'

describe Author do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:gra_id) }
end
