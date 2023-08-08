require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :percentage_discount }
    it { should validate_presence_of :quantity_threshold }
    it { should validate_numericality_of(:percentage_discount).is_greater_than(0).is_less_than_or_equal_to(100) }
    it { should validate_numericality_of(:quantity_threshold).is_greater_than(0) }
  end
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
  end
end
