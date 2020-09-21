require "rails_helper"

RSpec.describe "post with authentication", type: :request do
  let!(:a_user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:a_user_post) { create(:post, user_id: a_user.id, published: true) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let!(:a_auth_headers) { {'Authorization' => "Bearer #{a_user.auth_token}"} }
  let!(:other_auth_headers) { {'Authorization' => "Bearer #{other_user.auth_token}"} }

  describe "GET /posts/{id}" do
    context "with valid auth" do
      context "when requisting other's author post" do
        context "when post is public" do
          before { get "/posts/#{other_user_post.id}", headers: other_auth_headers }
          context "payload" do
            subject { JSON.parse(response.body) }
            it { is_expected.to include(:id) }
          end
          context "response" do
            subject { response }
            it { is_expected.to have_http_status(:ok) }
          end
        end
        context "when post is draft" do
          before { get "/posts/#{a_user_post.id}", headers: a_auth_headers }
          context "payload" do
            subject { JSON.parse(response.body) }
            it { is_expected.to include(:error) }
          end
          context "response" do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
          end          
        end
      end
      context "when requisiting user's post" do
        
      end
    end
  end

end