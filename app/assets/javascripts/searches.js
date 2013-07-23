$(function() {
	if($("#restaurantName").length > 0) {
		changeName(0, 0);
	}
})

var changeName = function(index, loopCount) {
	$("#restaurantName").text(window.restaurants[index]);

	if(loopCount == 1 && window.restaurants[index] == window.winner.name) {
		//show winner details

		return;
	}
	if(index < window.restaurants.length) {
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