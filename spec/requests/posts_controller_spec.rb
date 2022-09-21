require 'rails_helper'

RSpec.describe "Posts", type: :request do
  context "user not logged in" do
    shared_examples "returns unauthorized" do
      it "returns http 401" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns an unauthorized error" do
        subject
        expect(JSON.parse(response.body)).to eq({ "error" => "Not Authorized" })
      end
    end

    describe "GET /posts" do
      subject { get "/posts" }
      it_behaves_like "returns unauthorized"
    end

    describe "GET /posts/1" do
      subject { get "/posts/1" }
      it_behaves_like "returns unauthorized"
    end

    describe "POST /posts" do
      subject { post "/posts" }
      it_behaves_like "returns unauthorized"
    end

    describe "PUT /posts" do
      subject { put "/posts/1" }
      it_behaves_like "returns unauthorized"
    end

    describe "DELTE /posts" do
      subject { delete "/posts/1" }
      it_behaves_like "returns unauthorized"
    end
  end

  context "user logged in" do
    before(:all) do
      @user = create(:user)
      post "/authenticate", params: { email: @user.email, password: "123123123" }

      @authentication_code = JSON.parse(response.body)["auth_token"]
    end

    context "GET /index" do
      it "returns http success" do
        get "/posts", headers: { Authorization: "Bearer #{@authentication_code}"}

        expect(response).to have_http_status(:success)
      end

      context "returns posts" do
        let!(:post) { create(:post) }

        context "one post" do
          it "returns the post" do
            get "/posts", headers: { Authorization: "Bearer #{@authentication_code}"}

            expect(response.body).to eq([post].to_json)
          end
        end

        context "two posts" do
          let!(:post_2) { create(:post) }

          it "returns both posts" do
            get "/posts", headers: { Authorization: "Bearer #{@authentication_code}"}

            expect(response.body).to eq([post, post_2].to_json)
          end
        end
      end
    end

    context "GET /index/:id" do
      let!(:post) { create(:post) }

      it "returns post details" do
        get "/posts/#{post.id}", headers: { Authorization: "Bearer #{@authentication_code}"}

        expect(response).to have_http_status(:success)
        expect(response.body).to eq(post.to_json)
      end
    end

    context "POST /create" do
      it "reponds with http success" do
        post "/posts", headers: { Authorization: "Bearer #{@authentication_code}"},
          params: { post: { title: "post_title", content: "post_content" } }

        expect(response).to have_http_status(:success)
      end

      it "creates a post" do
        post "/posts", headers: { Authorization: "Bearer #{@authentication_code}"},
          params: { post: { title: "post_title", content: "post_content" } }

        expect(response.body).to eq(Post.last.to_json)
      end
    end

    context "PUT /update/:id" do
      context "trying to update another user post" do
        let!(:post) { create(:post) }

        it "raises an error" do
          put "/posts/#{post.id}", headers: { Authorization: "Bearer #{@authentication_code}"},
            params: { post: { title: "post_title_updated", published: true, content: "post_content_updated" } }

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq({ message: "Not allowed to update another person Post"}.to_json)
        end
      end

      context "updating users own post" do
        let!(:post) { create(:post, user: @user) }

        it "updates a post" do
          put "/posts/#{post.id}", headers: { Authorization: "Bearer #{@authentication_code}"},
            params: { post: { title: "post_title_updated", published: true, content: "post_content_updated" } }

          expect(response).to have_http_status(:ok)
          expect(post.reload.title).to eq("post_title_updated")
          expect(post.published).to eq(true)
          expect(post.content).to eq("post_content_updated")
        end
      end
    end

    context "DELETE /destroy/:id" do
      context "trying to delete another user post" do
        let!(:post) { create(:post) }

        it "raises an error" do
          delete "/posts/#{post.id}", headers: { Authorization: "Bearer #{@authentication_code}"}

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq({ message: "Not allowed to delete another person Post"}.to_json)
        end
      end

      context "updating users own post" do
        let!(:post) { create(:post, user: @user) }

        it "deletes a post" do
          delete "/posts/#{post.id}", headers: { Authorization: "Bearer #{@authentication_code}"}

          expect(response).to have_http_status(:ok)
          expect(Post.find_by(id: post.id)).to eq(nil)
        end
      end
    end
  end
end
