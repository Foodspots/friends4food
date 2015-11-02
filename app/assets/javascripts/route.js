function getCookie(cname) {
	var name = cname + "=";
	var ca = document.cookie.split(';');
	for(var i=0; i<ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1);
		if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
	}
	return "";
}

function showLocationRoute(position) {
	set_cookie_location_route(position.coords.latitude, position.coords.longitude);
}

function errorHandler(err) {
}

function set_cookie_location_route(latitude, longitude) {
	document.cookie = "latitude = "+latitude+";";
	document.cookie = "longitude = "+longitude+";";

	$(".route_form").submit();
}

$(function() {
	$(".route_form").on('submit', function () {
		// Check if cookies are set
		if (getCookie("latitude") != "" && getCookie("longitude") != ""){
			// Grab them and fill them into the form
			$("#saddr").val(getCookie("latitude") + ", " + getCookie("longitude"));
			return true;
		} else{
			// If not, ask for them
			if(navigator.geolocation){
				// timeout at 60000 milliseconds (60 seconds)
				var options = {timeout: 60000};
				geoLoc = navigator.geolocation;
				watchID = geoLoc.watchPosition(showLocationRoute, errorHandler, options);
			}else{
				alert("Sorry, browser does not support geolocation!");
			}
			return false;
		}
	});
});

