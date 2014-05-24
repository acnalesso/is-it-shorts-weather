require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'

get '/' do
  erb :shorts_weather
end

get '/get_weather' do
  nine_til_four_url = "http://www.accuweather.com/en/gb/isleworth/tw7-6/hourly-weather-forecast/328288?hour=33"
  weather = get_weather_for(nine_til_four_url)
  is_it_shorts_weather?(occurances_of_rain(weather[:forecast]), average_temp(weather[:temperatures])).to_s
end

def is_it_shorts_weather? occurances_of_rain, average_temp
  occurances_of_rain <= 2 && average_temp >= 18
end

def get_weather_for url
  {
    forecast: get_forecast_for(url),
    temperatures: get_temps_for(url)
  }
end

def get_forecast_for time_period
  data = Nokogiri::HTML(open(time_period))
  data.at_css("tr.forecast").css("div").map { |hour| hour.text }
end

def get_temps_for time_period
  data = Nokogiri::HTML(open(time_period))
  data.at_css("tr.realfeel").css("td").map { |hour| hour.text.scan(/(\d+)/) }
end

def occurances_of_rain weather
  occurances = weather.map { |w| w.scan(/(Showers|Rain)/) }
  occurances.flatten.size
end

def average_temp temperatures
  (temperatures.flatten.inject(0) { |sum, temp| sum + temp.to_i }).to_i / temperatures.flatten.size
end
