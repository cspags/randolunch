
$(function() {
	var x = $.parseJSON($("#result").text());
	$("#result").text(JSON.stringify(x, null, " "));
})