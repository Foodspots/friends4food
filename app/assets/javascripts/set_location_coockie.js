$( document ).ready(function() {
  if(navigator.geolocation){
    // timeout at 60000 milliseconds (60 seconds)
    var options = {timeout:60000};
    geoLoc = navigator.geolocation;
    watchID = geoLoc.watchPosition(showLocation, errorHandler, options);
  }else{
    alert("Sorry, browser does not support geolocation!");
  }
 
});

function showLocation(position) {
  set_coockie_location(position.coords.latitude, position.coords.longitude);
}

function set_coockie_location(latitude, longitude){
  document.cookie = "latitude = "+latitude+";";
  document.cookie = "longitude = "+longitude+";";
}