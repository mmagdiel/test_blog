require "rails_helper"

RSpec.describe "post endpoint", type: :request do

  describe "GET /post" do
    describe "without data in the BD" do    
      before { get '/post' }
      it "should return OK" do
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end
    end 

    describe "with data in the BD" do
      before { get '/post' }
      let(:posts) { crate_list(:post, 10, published: true) } # create_list: factory bot, let: rspec
      it "should return status code 200" do
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(posts.size)
        expect(response).to have_http_status(200)
      end
    end
  end
  describe "GET /post/{id}" do
    let(:post) { create(:post) }
    it "should return a post" do
      get "/post/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload[]).to eq(post.id)
      expect(response).to have_http_status(200)
    end
  end
end