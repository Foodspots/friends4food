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
  var latitude = position.coords.latitude;
  var longitude = position.coords.longitude;
  set_coockie_location(latitude, longitude);
}

function errorHandler(err) {
  if(err.code == 1) {
    alert("Error: Access is denied!");
  }else if( err.code == 2) {
    alert("Error: Position is unavailable!");
  }
}

function set_coockie_location(latitude, longitude){
  document.cookie="latitude="+latitude+";";
  document.cookie="longitude="+longitude+";";
}