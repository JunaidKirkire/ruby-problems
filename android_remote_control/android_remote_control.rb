require 'sinatra'
require 'open-uri'

get '/' do
  list_of_android_devices = `adb devices`
  list_of_android_devices
end

get '/start' do
  device_id = params[:device_id]
  url_to_open = params[:url]
  system("adb -s #{device_id} shell am set-debug-app --persistent com.android.chrome")
  system("adb -s #{device_id} shell am start -n com.android.chrome/com.google.android.apps.chrome.Main -d '#{url_to_open}'")
  url_to_open
end

get '/stop' do
  device_id = params[:device_id]
  system("adb -s #{device_id} shell am force-stop com.android.chrome")
  "Device #{device_id} stopped!"
end

get '/clean' do
  device_id = params[:device_id]
  system("adb -s #{device_id} shell pm clear com.android.chrome")
  "Device #{device_id} cleaned!"
end