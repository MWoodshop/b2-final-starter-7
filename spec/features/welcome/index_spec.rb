require 'rails_helper'

RSpec.describe 'welcome page' do
  it 'displays a link to the merchants view and a second link to the admin view' do
    visit root_path
    expect(page).to have_link('Merchants View')
    expect(page).to have_link('Admin View')
  end

  it 'links to the merchants view' do
    visit root_path
    click_link('Merchants View')
    expect(current_path).to eq(merchants_path)
  end

  it 'links to the admin view' do
    visit root_path
    click_link('Admin View')
    expect(current_path).to eq(admin_merchants_path)
  end
end
