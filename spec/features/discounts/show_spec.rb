require 'rails_helper'

RSpec.describe 'discount show' do
  before :each do
    load_test_data
  end

  # User Story 4: Merchant Bulk Discount Show

  # As a merchant
  # When I visit my bulk discount show page
  # Then I see the bulk discount's quantity threshold and percentage discount
  it 'has a show page for each discount' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_link(@discount_1.id.to_s, href: merchant_discount_path(@merchant1, @discount_1))
    click_link @discount_1.id.to_s
    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content(@discount_1.percentage_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
  end

  #   User Story 5: Merchant Bulk Discount Edit

  # As a merchant
  # When I visit my bulk discount show page
  # Then I see a link to edit the bulk discount
  # When I click this link
  # Then I am taken to a new page with a form to edit the discount
  # And I see that the discounts current attributes are pre-populated in the form
  # When I change any/all of the information and click submit
  # Then I am redirected to the bulk discount's show page
  # And I see that the discount's attributes have been updated
  it 'has a link to edit each discount' do
    visit merchant_discount_path(@merchant1, @discount_1)
    expect(page).to have_link('Edit Discount')
    click_link 'Edit Discount'
    fill_in 'discount[percentage_discount]', with: 90
    fill_in 'discount[quantity_threshold]', with: 9
    click_button 'Submit'
    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content('Discount was successfully updated.')
    expect(page).to have_content('90')
    expect(page).to have_content('9')
  end

  it 'can also support changing only one attribute' do
    visit merchant_discount_path(@merchant1, @discount_1)
    expect(page).to have_link('Edit Discount')
    click_link 'Edit Discount'
    fill_in 'discount[percentage_discount]', with: 90
    click_button 'Submit'
    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content('Discount was successfully updated.')
    expect(page).to have_content('90')
    expect(page).to have_content('20')
  end

  it 'supports a sad path on editing a discount' do
    visit merchant_discount_path(@merchant1, @discount_1)
    expect(page).to have_link('Edit Discount')
    click_link 'Edit Discount'
    fill_in 'discount[percentage_discount]', with: 'aa'
    fill_in 'discount[quantity_threshold]', with: ''
    click_button 'Submit'
    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content('Percentage discount is not a number')
    expect(page).to have_content('Quantity threshold is not a number')
  end
end
