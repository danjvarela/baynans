class Iex < ApplicationRecord
  def self.client
    IEX::Api::Client.new(
      publishable_token: ENV["iex_publishable_token"],
      secret_token: ENV["iex_secret_token"],
      endpoint: "https://cloud.iexapis.com/v1"
    )
  end
end
