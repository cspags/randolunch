$(function() {
	if($("#restaurantName").length > 0) {
		changeName(0, 0);
	}

	if($(".distance-unit").length > 0) {
		$(".distance-unit").change(onDistanceUnitChange);
	}
})

var changeName = function(index, loopCount) {
	$("#restaurantName").text(restaurants[index]);

	if(loopCount == 3 && restaurants[index] == winner.name) {
		displayWinnerDetails();
		Maps.initialize(winner.address_for_geocode);
		//Maps.display();
		return;
	}
	if(index < restaurants.length) {
		index++;
		setTimeout(function() { changeName(index, loopCount); }, 75);
	}
	else {
		//here we've completed one cycle
		loopCount++;
		index = 0;
		setTimeout(function() { changeName(index, loopCount); }, 75);
	}

};

var displayWinnerDetails = function() {
	$("#rating", "#restaurantDetails").attr("src", winner.rating_img_url)
		.attr("alt", winner.rating_text + " star rating")
		.attr("title", winner.rating_text + " star rating");
	$("#phone", "#restaurantDetails").text(winner.phone);
	$("#reviews", "#restaurantDetails").text(winner.review_count + " reviews");
	$("#url", "#restaurantDetails").attr("href", winner.url);

	var address = "";
	$.each(winner.address, function(index, value) {
		address += value + "<br />";
	})
	$("#address", "#restaurantDetails").html(address);	

	$("#restaurantDetails").fadeIn("slow");
}

var milesOptions = ["0.5", "1", "2", "5", "10", "20"];
var metersOptions = ["1", "2", "5", "10", "15", "30"];

var onDistanceUnitChange = function() {
	// get whether miles or meters was selected
	var distanceUnit = $(".distance-unit option:selected").text();
	var options = milesOptions;
	var defaultOption = "1";
	if (distanceUnit == "kilometers") {
		options = metersOptions;
		defaultOption = "2";
	}

	var distance = $(".distance");
	distance.empty(); // remove old options

	$.each(options, function(index, value) {
		var newOption = $("<option></option>").attr("value", value).text(value);
		if(value == defaultOption) {
			newOption.attr("selected", "selected")
		}

		distance.append(newOption);
	});
}
