$(document).ready(function(){
  getWeather();
});

function getWeather(){
  $.ajax({
    url: "/get_weather"
  }).done(function(result){
    if(result == "true"){
      setShortsWeather();
    } else {
      setNotShortsWeather();
    }
  });
}

function setShortsWeather(){
  $(".answer").addClass("yes");
  $(".answer").html("Yes");
}

function setNotShortsWeather(){
  $(".answer").addClass("no");
  $(".answer").html("No");
}
