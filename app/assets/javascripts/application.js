//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	$(".availability_plan .free_cell_style_1, .availability_plan .free_cell_style_2, .availability_plan .booked_cell_style").click(function(){
		alert($(this).html() + " - " + $(this).attr("data-court") + " - " + $(this).attr("data-begin") + " Uhr bis " + $(this).attr("data-end") + " Uhr");
	});
});