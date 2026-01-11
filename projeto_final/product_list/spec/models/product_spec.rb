require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) { build(:product) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_numericality_of(:value).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0).only_integer }
  end
end