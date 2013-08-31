var Maps = (function() {
	var _public = {};

	var geocoder;
	var map;
	var infowindow;
	var marker;

	_public.initialize = function(address) {
		infowindow = new google.maps.InfoWindow();
		geocoder = new google.maps.Geocoder();
		getLatLng(address);
	}

	_public.display = function(latlng) {
		var mapOptions = {
			zoom: 16,
			center: latlng,
			mapTypeId: 'roadmap'
		}
		map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
		marker = new google.maps.Marker({
			position: latlng,
			map: map
		});
	}

	//private methods
	var getLatLng = function(address) {
		geocoder.geocode( { 'address': address}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				_public.display(results[0].geometry.location);
			} 
			else {
			 	alert('Geocode was not successful for the following reason: ' + status);
			}
		});
	}

	return _public;
})();




