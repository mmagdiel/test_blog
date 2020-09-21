require "rails_helper"

RSpec.describe "post endpoint", type: :request do

  describe "GET /posts" do
    describe "without data in the BD" do    
      before { get '/posts' }
      it "should return OK" do
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(:ok)
      end
    end 

    describe "Search data" do    
      let!(:hola_mundo) { create(:published_post, title: "Hola Mundo") }
      let!(:hola_rails) { create(:published_post, title: "Hola Rails") }
      let!(:curso_ruby) { create(:published_post, title: "Curso Ruby") }
      it "should filter posts by title" do
        get "/posts?search=Hola"
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(2)
        expect(payload.map{ |p| p["id"] }.sort).to eq([hola_mundo.id, hola_rails.id].sort)
        expect(payload).to_not be_empty
        expect(payload).to_not be_empty
        expect(response).to have_http_status(:ok)
      end
    end 

    describe "with data in the BD" do
      let!(:posts) { create_list(:post, 10, published: true) } # create_list: factory bot, let: rspec
      before { get '/posts' }
      it "should return status code 200" do
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(posts.size)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /posts/{id}" do
    let!(:post) { create(:post, published: true) }
    it "should return a post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(post.id)
      expect(payload["title"]).to eq(post.title)
      expect(payload["content"]).to eq(post.content)
      expect(payload["published"]).to eq(post.published)
      expect(payload["author"]["name"]).to eq(post.user.name)
      expect(payload["author"]["email"]).to eq(post.user.email)
      expect(payload["author"]["id"]).to eq(post.user.id)
      expect(response).to have_http_status(:ok)
    end
  end
end