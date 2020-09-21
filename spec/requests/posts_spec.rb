require "rails_helper"

RSpec.describe "post endpoint", type: :request do

  describe "GET /posts" do
    describe "without data in the BD" do    
      before { get '/posts' }
      it "should return OK" do
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end
    end 

    describe "with data in the BD" do
      let!(:posts) { create_list(:post, 10, published: true) } # create_list: factory bot, let: rspec
      before { get '/posts' }
      it "should return status code 200" do
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(posts.size)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /posts/{id}" do
    let!(:post) { create(:post) }
    it "should return a post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(post.id)
      expect(response).to have_http_status(200)
    end
  end
  
end