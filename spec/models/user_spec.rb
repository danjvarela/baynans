require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe "User type" do
    it "should have a default value of `trader`" do
      created_user = user
      expect(created_user.trader?).to be true
    end
  end
end
