$(function() {
	if($("#restaurantName").length > 0) {
		changeName(0, 0);
	}
})

var changeName = function(index, loopCount) {
	$("#restaurantName").text(restaurants[index]);

	if(loopCount == 1 && restaurants[index] == winner.name) {
		displayWinnerDetails();
		Maps.initialize(winner.address_for_geocode);
		Maps.display();
		return;
	}
	if(index < restaurants.length) {
		index++;
		setTimeout(function() { changeName(index, loopCount); }, 100);
	}
	else {
		//here we've completed one cycle
		loopCount++;
		index = 0;
		setTimeout(function() { changeName(index, loopCount); }, 100);
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
