require 'rails_helper'

RSpec.describe 'merchants index page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Pet Store')
    @merchant3 = Merchant.create!(name: 'Jewelry Shop')
  end

  it 'can see all merchants names' do
    visit merchants_path
    expect(page).to have_content(@merchant1.name)
    expect(page).to have_content(@merchant2.name)
    expect(page).to have_content(@merchant3.name)
  end

  it 'can click on a merchants name and be taken to that merchants dashboard page' do
    visit merchants_path
    click_link(@merchant1.name)
    expect(current_path).to eq(merchant_dashboard_index_path(@merchant1))
  end
end
