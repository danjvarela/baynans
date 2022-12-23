require "rails_helper"

RSpec.describe "Admins", type: :request do
  let(:user) do
    user = User.new(attributes_for(:user))
    user.skip_confirmation!
    user.save!
    user
  end
  let(:user_attributes) { attributes_for :user }

  before :each do
    admin = User.new attributes_for(:user, user_type: :admin)
    admin.skip_confirmation!
    admin.save!

    sign_in admin
  end

  describe "GET /admin/users" do
    it "should return http success" do
      get users_path
      expect(response).to be_successful
    end

    it "should render all users page" do
      get users_path
      expect(response).to render_template(:index)
    end
  end

  describe "POST /admin/users" do
    context "with correct params" do
      it "should create a new user" do
        before_count = User.count
        post users_path, params: {user: user_attributes}
        expect(User.count).to eq(before_count + 1)
      end

      it "should redirect to root_path" do
        post users_path, params: {user: user_attributes}
        expect(response).to redirect_to root_path
      end
    end

    context "with incorrect params" do
      it "should not create a new user" do
        before_count = User.count
        post users_path, params: {user: {email: nil, password: nil}}
        expect(User.count).to eq(before_count)
      end

      it "should redirect to root_path" do
        post users_path, params: {user: user_attributes}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /admin/users/new" do
    it "should return http success" do
      get new_user_path
      expect(response).to be_successful
    end

    it "should render new user page" do
      get new_user_path
      expect(response).to render_template(:new)
    end
  end

  describe "GET /admin/users/:id/edit" do
    it "should return http success" do
      get edit_user_path(user)
      expect(response).to be_successful
    end

    it "should render new user page" do
      get edit_user_path(user)
      expect(response).to render_template(:edit)
    end
  end

  describe "GET /admin/users/:id" do
    it "should return http success" do
      get user_path(user)
      expect(response).to be_successful
    end

    it "should render new user page" do
      get user_path(user)
      expect(response).to render_template(:show)
    end
  end
  
  # Skip this for now
  # Updating a user's email triggers confirmation
  # describe "PUT /admin/users/:id" do
  #   let(:new_email) { generate :email }
  #
  #   it "should update a user's detail" do
  #     put user_path(user), params: {user: {email: new_email}}
  #     expect(user.email).to eq(new_email)
  #   end
  #
  #   it "should redirect to root path" do
  #     put user_path(user), params: {user: {email: new_email}}
  #     expect(response).to redirect_to(root_path)
  #   end
  # end

  describe "DELETE /admin/users/:id" do
    it "should delete a user" do
      created_user = user # just call user to trigger user creation
      before_count = User.count
      delete user_path(created_user)
      expect(User.count).to eq(before_count - 1)
    end

    it "should redirect to root path" do
      delete user_path(user)
      expect(response).to redirect_to root_path
    end
  end

  describe "GET /admin/notifications" do
    it "should return http success" do
      get admin_notifications_path
      expect(response).to be_successful
    end

    it "should render notifications page" do
      get admin_notifications_path
      expect(response).to render_template(:notifications)
    end
  end
end
