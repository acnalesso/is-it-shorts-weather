require 'sinatra'
require 'open-uri'
require 'nokogiri'

get '/' do
  nine_til_four = "http://www.accuweather.com/en/gb/isleworth/tw7-6/hourly-weather-forecast/328288?hour=33"
  weather = get_weather_for(nine_til_four)
  temperatures = get_temps_for(nine_til_four)
  @shorts_weather = is_it_shorts_weather?(occurances_of_rain(weather), average_temp(temperatures))
  erb :shorts_weather
end

def is_it_shorts_weather? occurances_of_rain, average_temp
  occurances_of_rain <= 2 && average_temp >= 18
end

def get_weather_for time_period
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
