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
      let!(:hola_mundo) { create(:post, title: "Hola Mundo") }
      let!(:hola_rails) { create(:post, title: "Hola Rails") }
      let!(:curso_ruby) { create(:post, title: "Curso Ruby") }
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
    let!(:post) { create(:post) }
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
  
  describe "POST /posts" do
    let!(:user) { create(:user) }
    it "should create a post" do
      req_payload = {
        post: {
          title: "titulo",
          content: "content",
          published: false,
          user_id: user.id
        }
      }
      # POST HTTP
      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to_not be_nil
      expect(response).to have_http_status(:created)
    end
  end

  describe "POST /posts" do
    let!(:user) { create(:user) }
    it "should return error message on invalid post" do
      req_payload = {
        post: {
          content: "content",
          published: false,
          user_id: user.id
        }
      }
      # POST HTTP
      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["error"]).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /posts/{id}" do
    let!(:post) { create(:post) }
    it "should update a post" do
      req_payload = {
        post: {
          title: "titulo",
          content: "content",
          published: true,
        }
      }
      # POST HTTP
      put "/posts/#{post.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(post.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /posts/{id}" do
    let!(:post) { create(:post) }
    it "should return error message on invalid post" do
      req_payload = {
        post: {
          title: nil,
          content: nil,
          published: true,
        }
      }
      # POST HTTP
      put "/posts/#{post.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["error"]).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end