require 'sinatra'
require 'securerandom'

class KeyAttributes

  def initialize
    @last_blocked_time = @last_keep_alive = Time.now
  end

  def is_blocked?
    (Time.now - @last_blocked_time) <= 60 # each key is blocked for 60 secs
  end

  attr_accessor :last_blocked_time, :last_keep_alive
end

class KeyManager
  # If 'last_keep_alive' is more than 5 minutes, purge that key
  def KeyManager.purge_silent_keys(hash_keys)
    hash_keys.each do |key, value|
      hash_keys.delete key if (Time.now - value.last_keep_alive) > 300
    end
  end

  def KeyManager.fetch_key(hash_keys)
    random_api_key = hash_of_keys.keys.sample.to_sym #choose any random key
    unless hash_of_keys[random_api_key].is_blocked?
      hash_of_keys[random_api_key].last_blocked_time = Time.now
      hash_of_keys[random_api_key].last_keep_alive = Time.now
    else
      random_api_key = SecureRandom.base64.gsub("/", "").to_sym
      hash_of_keys[random_api_key] = KeyAttributes.new
    end
    random_api_key
  end
end

hash_of_keys = {}

# Endpoint to generate keys
get '/generate' do
  KeyManager.purge_silent_keys(hash_of_keys)
  hash_of_keys[SecureRandom.base64.gsub("/", "").to_sym] = KeyAttributes.new
end

# Endpoint to see all keys (for dev purposes)
get '/see_all_keys' do
  hash_of_keys.inspect
end

# Endpoint to inspect a particular key (for dev purposes)
get '/inspect/:key' do
  unless hash_of_keys[params[:key]].nil?
    "#{hash_of_keys[params[:key].to_sym].is_blocked?} #{hash_of_keys[params[:key].to_sym].last_blocked_time} #{hash_of_keys[params[:key].to_sym].last_keep_alive}"
  else
    "Key #{params[:key]} does not exist"
  end
end

get '/fetch' do
  KeyManager.purge_silent_keys(hash_of_keys)
  random_api_key = KeyManager.fetch_key(hash_of_keys)
  "#{random_api_key}"
end

get '/unblock/:key' do
  api_key = params[:key].to_sym
  if hash_of_keys[api_key].nil?
    "Key doesn't exist!" 
  else
    hash_of_keys[api_key].last_blocked_time = Time.now + 60
    "Unblock of key - #{params[:key]} was successful"
  end
end

get '/delete/:key' do
  hash_of_keys.delete params[:key].to_sym
  "Deleted key - #{params[:key]}"
end

get '/keep_alive/:key' do
  api_key = params[:key].to_sym
  if hash_of_keys[api_key].nil?
    "Key doesn't exist!" 
  else
    hash_of_keys[api_key].last_keep_alive = Time.now
    "Keep alive for #{api_key} was successful"
  end
end
