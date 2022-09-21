require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/users"
      expect(response).to have_http_status(:success)
    end

    context "returns the users" do
      let!(:user) { create(:user) }

      it "returns the user" do
        get "/users"
        expect(response.body).to eq(User.all.to_json)
      end
    end
  end

  describe "POST /create" do
    it "reponds with http success" do
      post "/users", params: { user: { name: "user_example", email: "user@example.com", password: "123123123" } }
      expect(response).to have_http_status(:success)
    end

    it "reponds with name and email" do
      post "/users", params: { user: { name: "user_example", email: "user@example.com", password: "123123123" } }
      expect(response.body).to eq({ name: "user_example", email: "user@example.com" }.to_json)
    end
  end
end
