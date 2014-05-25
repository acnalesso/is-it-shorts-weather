$(document).ready(function(){
  setup();
});

function setup(){
  navigator.geolocation.getCurrentPosition(function(position){
    getWeather(position.coords.latitude, position.coords.longitude);
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
