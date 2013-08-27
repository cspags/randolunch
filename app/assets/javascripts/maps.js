var Maps = (function() {
	var pub = {};

	var geocoder;
	var map;
	var infowindow;
	var marker;

	pub.initialize = function(address) {
		infowindow = new google.maps.InfoWindow();
		geocoder = new google.maps.Geocoder();
		getLatLng(address);
	}

	pub.display = function(latlng) {
		var mapOptions = {
			zoom: 15,
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
				pub.display(results[0].geometry.location);
			} 
			else {
			 	alert('Geocode was not successful for the following reason: ' + status);
			}
		});
	}

	return pub;
})();




