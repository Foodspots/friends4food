(function (){
	function set_cookie_location(latitude, longitude){
		document.cookie = "latitude = " + latitude + ";";
		document.cookie = "longitude = " + longitude + ";";
	}

	$(function(){
		$("a.location_before").on('click', function(){
			var that = $(this);
			var lat = sessionStorage.getItem('lat');
			var lon = sessionStorage.getItem('lon');

			if(lat && lon){
				set_cookie_location(lat, lon);
				return true;
			}else{
				if(navigator.geolocation){
					var options = {timeout: 60000};
					var geoLoc = navigator.geolocation;
					geoLoc.watchPosition(function(position){
						var lat = position.coords.latitude;
						var lon = position.coords.longitude;

						sessionStorage.setItem('lat', lat);
						sessionStorage.setItem('lon', lon);
						set_cookie_location(lat, lon);
						window.location = that.href('a');
					}, function(){
					}, options);
				}else{
					alert("Sorry, browser does not support geolocation!");
				}
				return false;
			}
		});
	});
}());

