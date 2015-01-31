//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	$(".availability_plan .free_cell_style_1, .availability_plan .free_cell_style_2, .availability_plan .booked_cell_style").click(function(){
		//alert($(this).html() + " - " + $(this).attr("data-court") + " - " + $(this).attr("data-begin") + " Uhr bis " + $(this).attr("data-end") + " Uhr");
		if($(this).attr("data-bookable") == "1"){
			if($(this).attr("data-preselected") == "0"){
				$(this).css("background","#837E7C");
				$(this).attr("data-preselected","1");
			}
			else{
				$(this).css("background",$(this).attr("data-standard_cell_color"));
				$(this).attr("data-preselected","0");
			}
		}
		else{
			$(this).css("background","red");
		}
	});
	$("#book_marked_cells_button").click(function(){
		test_alert_string = "";
		$(".availability_plan td[data-preselected='1']").each(function(i){
			test_alert_string += $(this).attr("data-court") + " - " + $(this).attr("data-begin") + " Uhr bis " + $(this).attr("data-end") + " Uhr\n";
		});
		if(test_alert_string == ""){
			test_alert_string = "Du musst Tabellenzellen anklicken, um diese für eine Buchung zu markieren!";
		}
		alert(test_alert_string);
	});
});