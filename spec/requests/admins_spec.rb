require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  let(:user) { create :user }
  let(:user_attributes) { attributes_for :user }

  before :each do
    sign_in user
  end

  describe 'GET /admin/users' do
    it 'should return http success' do
      get users_path
      expect(response).to be_successfull
    end

    it 'should render all users page' do
      get users_path
      expect(response).to render_template(:index)
    end
  end

  describe 'POST /admin/users' do
    context 'with correct params' do
      it 'should create a new user' do
        before_count = User.count
        post users_path, params: { user: user_attributes }
        expect(User.count).to eq(before_count + 1)
      end

      it 'should redirect to root_path' do
        post users_path, params: { user: user_attributes }
        expect(response).to redirect_to root_path
      end
    end

    context 'with incorrect params' do
      it 'should not create a new user' do
        before_count = User.count
        post users_path, params: { user: {} }
        expect(User.count).to eq(before_count)
      end

      it 'should redirect to root_path' do
        post users_path, params: { user: user_attributes }
        expect(response).to redirect_to root_path
      end

      it 'should return http unprocessable entity' do
        post users_path, params: { user: user_attributes }
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'GET /admin/users/new' do
    it 'should return http success' do
      get new_user_path
      expect(response).to be_successfull
    end

    it 'should render new user page' do
      get new_user_path
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /admin/users/:id/edit' do
    it 'should return http success' do
      get edit_user_path(user)
      expect(response).to be_successfull
    end

    it 'should render new user page' do
      get edit_user_path(user)
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET /admin/users/:id' do
    it 'should return http success' do
      get user_path(user)
      expect(response).to be_successfull
    end

    it 'should render new user page' do
      get user_path(user)
      expect(response).to render_template(:show)
    end
  end

  describe 'PUT /admin/users/:id' do
    it "should update a user's detail" do
      new_email = 'custom_email@example'
      put user_path(user), params: { user: { email: new_email } }
      expect(user.email).to eq(new_email)
    end

    it 'should redirect to root path' do
      put user_path(user), params: { user: { email: new_email } }
      expect(response).to redirect_to root_path
    end
  end

  describe 'DELETE /admin/users/:id' do
    it 'should delete a user' do
      created_user = user
      before_count = User.count
      delete user_path(created_user)
      expect(User.count).to eq(before_count - 1)
    end

    it 'should redirect to root path' do
      delete user_path(created_user)
      expect(response).to redirect_to root_path
    end
  end
end
