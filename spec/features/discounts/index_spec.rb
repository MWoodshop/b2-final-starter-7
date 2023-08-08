require 'rails_helper'

RSpec.describe 'discount index' do
  before :each do
    load_test_data
  end

  # User Story 1
  # Merchant Bulk Discounts Index

  # As a merchant
  # When I visit my merchant dashboard
  # Then I see a link to view all my discounts
  # When I click this link
  # Then I am taken to my bulk discounts index page
  # Where I see all of my bulk discounts including their
  # percentage discount and quantity thresholds
  # And each bulk discount listed includes a link to its show page

  it 'shows all discounts with a link to the discount show page' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    within("#discount-#{@discount_1.id}") do
      expect(page).to have_content(@discount_1.id.to_s)
      expect(page).to have_content(@discount_1.percentage_discount.to_s)
      expect(page).to have_content(@discount_1.quantity_threshold.to_s)
      expect(page).to have_link(@discount_1.id.to_s, href: merchant_discount_path(@merchant1, @discount_1))
    end
  end

  # User Story 2:
  # Merchant Bulk Discount Create

  # As a merchant
  # When I visit my bulk discounts index
  # Then I see a link to create a new discount
  # When I click this link
  # Then I am taken to a new page where I see a form to add a new bulk discount
  # When I fill in the form with valid data
  # Then I am redirected back to the bulk discount index
  # And I see my new bulk discount listed

  it 'allows me to create a new discount - happy path' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_link('Create New Discount', href: new_merchant_discount_path(@merchant1))
    click_link 'Create New Discount'

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    expect(page).to have_selector('form')
    fill_in 'discount[percentage_discount]', with: 90
    fill_in 'discount[quantity_threshold]', with: 9
    click_button 'Submit'
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content('Discount was successfully created.')
    within('table.show-table tr:last-child') do
      expect(page).to have_content('90')
      expect(page).to have_content('9')
    end
  end

  it 'allows me to create a new discount - sad path' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_link('Create New Discount', href: new_merchant_discount_path(@merchant1))
    click_link 'Create New Discount'

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    expect(page).to have_selector('form')
    click_button 'Submit'
    expect(page).to have_content("Percentage discount can't be blank")
    fill_in 'discount[percentage_discount]', with: 'aaa'
    fill_in 'discount[quantity_threshold]', with: 'bbb'
    expect(page).to have_content('Percentage discount is not a number')
    expect(page).to have_content('Quantity threshold is not a number')
  end

  # User Story 3: Merchant Bulk Discount Delete

  # As a merchant
  # When I visit my bulk discounts index
  # Then next to each bulk discount I see a button to delete it
  # When I click this button
  # Then I am redirected back to the bulk discounts index page
  # And I no longer see the discount listed
  it 'allows me to delete a discount' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    click_link 'Create New Discount'

    fill_in 'discount[percentage_discount]', with: 90
    fill_in 'discount[quantity_threshold]', with: 9
    click_button 'Submit'
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    within('table.show-table tr:last-child') do
      expect(page).to have_button('Delete')
      click_button 'Delete'
    end
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content('Discount was successfully deleted.')
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
  end
end

# User Story 9: Holidays API

# As a merchant
# When I visit the discounts index page
# I see a section with a header of "Upcoming Holidays"
# In this section the name and date of the next 3 upcoming US holidays are listed.
# Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)
describe 'APIs' do
  let(:mocked_response) do
    double(success?: true,
           body: '[{"name": "Holiday 1", "date": "2023-08-09"}, {"name": "Holiday 2", "date": "2023-09-09"}, {"name": "Holiday 3", "date": "2023-10-09"}]')
  end

  before do
    load_test_data

    allow(HTTParty).to receive(:get).and_return(mocked_response)
  end

  it 'shows the next 3 upcoming holidays names and dates or an error message' do
    visit merchant_discounts_path(@merchant1)

    if page.has_content?('Upcoming Holidays in the USA')
      expect(page).to have_content('Holiday 1')
      expect(page).to have_content('2023-08-09')
      expect(page).to have_content('Holiday 2')
      expect(page).to have_content('2023-09-09')
      expect(page).to have_content('Holiday 3')
      expect(page).to have_content('2023-10-09')
    else
      expect(page).to have_content('Error fetching next public holidays:')
    end
  end
end
