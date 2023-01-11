require 'rails_helper'

RSpec.describe AdminMailer, type: :mailer do
  let(:user) do
    user = build :user
    user.skip_confirmation!
    user.save!
    user
  end

  describe 'itself' do
    it 'sends an email as a background job' do
      expect do
        AdminMailer.with(user:).approve_user_email.deliver_later
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end
  end

  describe 'email details' do
    it 'renders the headers' do
      mail = AdminMailer.with(user:).approve_user_email
      expect(mail.to).to eq([user.email])
    end
  end
end
