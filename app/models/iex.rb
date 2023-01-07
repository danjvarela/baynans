class Iex < ApplicationRecord
  def self.client
    IEX::Api::Client.new(
      publishable_token: ENV["iex_publishable_token"],
      secret_token: ENV["iex_secret_token"],
      endpoint: "https://cloud.iexapis.com/v1"
    )
  end

  def self.most_active_stocks
    self.client.stock_market_list(:mostactive, {listLimit: 20})
  end
end
