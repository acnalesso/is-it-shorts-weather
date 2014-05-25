$(document).ready(function(){
  setup();
});

function setup(){
  navigator.geolocation.getCurrentPosition(function(position){
    getAddress(position.coords.latitude, position.coords.longitude);
    getWeather(position.coords.latitude, position.coords.longitude);
  });
}

function getAddress(lat, long){
  $.ajax({
    url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + long
  }).done(function(response){
    $(".address").text(response.results[0].formatted_address);
  });
}

function getWeather(lat, long){
  $.ajax({
    url: "/get_forecast/" + lat + "/" + long
  }).done(function(result){
    if (shortsWeather(result)) {
      setShortsWeather();
    } else {
      setNotShortsWeather();
    }
  });
}

function shortsWeather(weather){
  temps = $.map(weather.forecast, function(data){
    return data.temp;
  });
  summary = $.map(weather.forecast, function(data){
    return data.summary;
  });
  return (isHotEnough(temps));
}

function isHotEnough(temps){
  var sumOfTemps = 0
  $(temps).each(function(temp){
    sumOfTemps += temp;
  });
  return ((sumOfTemps / temps.length) >= 18);
}

function setShortsWeather(){
  $(".answer").addClass("yes");
  $(".answer").html("Yes");
}

function setNotShortsWeather(){
  $(".answer").addClass("no");
  $(".answer").html("No");
}
