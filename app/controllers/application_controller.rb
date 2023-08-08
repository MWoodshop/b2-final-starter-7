class ApplicationController < ActionController::Base
  before_action :get_next_three_holidays

  def get_next_three_holidays
    country_code = 'us'
    url = "https://date.nager.at/api/v3/NextPublicHolidays/#{country_code}"

    response = HTTParty.get(url)

    if response.success?
      @next_three_holidays = JSON.parse(response.body).first(3)
    else
      @error_message = "Error fetching next public holidays: #{response.code} - #{response.body}"
      @next_three_holidays = []
    end
  end
end
