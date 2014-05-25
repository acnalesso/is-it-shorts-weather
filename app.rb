require 'sinatra'
require 'faraday'
require 'json'
require 'date'

get '/' do
  erb :shorts_weather
end

get '/get_forecast/:lat/:long' do
  content_type :json
  @tomorrows_forecast = tomorrows_hourly_forecast_for(params[:lat], params[:long]).compact
  {forecast: tomorrows_nine_til_five_forecast}.to_json
end

def tomorrows_hourly_forecast_for(lat, long)
  response = weather.get("#{lat},#{long}?units=si")
  body = JSON.parse(response.body)
  body['hourly']['data'].map { |hour| get_temp_and_summary(hour) if tomorrow?(Time.at(hour['time'])) }
end

def weather
  Faraday.new("https://api.forecast.io/forecast/c957d1bfacf86b27d11f25b5fd8d4c50") do |faraday|
    faraday.response :logger
    faraday.adapter Faraday.default_adapter
  end
end

def tomorrows_nine_til_five_forecast
  @tomorrows_forecast.find_all { |hour| (hour[:time].hour >= 9) && (hour[:time].hour <= 17) }
end

def get_temp_and_summary data
  { temp: data['temperature'], summary: data['summary'], time: Time.at(data['time']) }
end

def tomorrow? time
  time.day == Time.now.day + 1
end
