ENV['RACK_ENV'] = 'test'

require '../key_server_problem.rb'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

describe 'The Key Server App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  arr_api_keys = []

  # Fetch all keys after generating. Shouldn't be an empty hash.
  it "fetches all keys" do
    5.times { get '/generate'}
    get "/see_all_keys"
    #puts last_response.body
    arr_api_keys = last_response.body.scan(/"\w+==/)#.collect { |ele| ele.gsub(/"\""/, "") }
    puts arr_api_keys
    expect(last_response.body).to_not eq("{}")
  end

  it "fetch a key just after they're generated" do
    5.times { get '/generate'}
    get '/fetch'
    #puts last_response.body
    #expect(last_response).to be_ok
    expect(last_response.body).to eq('Error 404. Key not found.')
  end


  it "unblocks a key" do
    puts "Trying to unblock some valid key"
    random_key = arr_api_keys.first.gsub "\"", ""
    get "/unblock/#{random_key}"
    expect(last_response.body).to eq("Unblock of key - #{random_key} was successful")

    puts "Trying to unblock some random key"
    random_key = "somekey"
    get "/unblock/#{random_key}"
    expect(last_response.body).to eq('Key doesn\'t exist!')
  end

  it "deletes a key" do
    random_key = arr_api_keys.first.gsub "\"", ""
    get "/delete/#{random_key}"
    #puts last_response.body
    expect(last_response.body).to eq("Deleted key - #{random_key}")
  end

  it "keeps the key alive" do
    puts "Trying to keep alive some valid key"
    puts arr_api_keys
    random_key = arr_api_keys.first.gsub "\"", ""
    get "/keep_alive/#{random_key}"
    expect(last_response.body).to eq("Keep alive for #{random_key} was successful")

    puts "Trying to keep alive some random key"
    random_key = "somekey"
    get "/keep_alive/#{random_key}"
    expect(last_response.body).to eq('Key doesn\'t exist!')
  end
end