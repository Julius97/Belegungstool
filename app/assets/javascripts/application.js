//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	$(".availability_plan .free_cell_style_1, .availability_plan .free_cell_style_2, .availability_plan .booked_cell_style").click(function(){
		if($(this).attr("data-bookable") == "1"){
			if($(this).attr("data-preselected") == "0"){
				if($(".availability_plan td[data-preselected='1']").attr("data-court-id") != $(this).attr("data-court-id") || $(".availability_plan td[data-preselected='1']").last().attr("data-end") != $(this).attr("data-begin")){
					$(".availability_plan td[data-preselected='1']").each(function(i){
						$(this).css("background", $(this).attr("data-standard_cell_color"));
						$(this).attr("data-preselected","0");
					});
				}
				$(this).css("background","#837E7C");
				$(this).attr("data-preselected","1");
			}
			else{
				$(".availability_plan td[data-preselected='1']").each(function(i){
					$(this).css("background", $(this).attr("data-standard_cell_color"));
					$(this).attr("data-preselected","0");
				});
				$(this).css("background","#837E7C");
				$(this).attr("data-preselected","1");
			}
		}
		else{
			alert($(this).attr("data-court") + " ist vom " + $(this).attr("data-begin") + " Uhr bis " + $(this).attr("data-end") + " Uhr bereits belegt!");
		}
	});
	$("#book_marked_cells_button").click(function(){
		if($("#user_id").val() != "-1"){
			alert_string = "";
			
			if($(".availability_plan td[data-preselected='1']").length > 0){
				//alert_string += $(this).attr("data-court") + " - " + $(this).attr("data-begin") + " Uhr bis " + $(this).attr("data-end") + " Uhr\n";

				court_id = parseInt($(".availability_plan td[data-preselected='1']").first().attr("data-court-id"));
				user_id = parseInt($("#user_id").val());

				start_datetime = $(".availability_plan td[data-preselected='1']").first().attr("data-begin").split(" ");
				start_date = start_datetime[0];
				start_time = start_datetime[1];
				start_date_arr = start_date.split(".");
				start_day = parseInt(start_date_arr[0]);
				start_month = parseInt(start_date_arr[1]);
				start_year = parseInt(start_date_arr[2]);
				start_time_arr = start_time.split(":");
				start_hour = parseInt(start_time_arr[0]);
				start_min = parseInt(start_time_arr[1]);

				end_datetime = $(".availability_plan td[data-preselected='1']").last().attr("data-end").split(" ");
				end_date = end_datetime[0];
				end_time = end_datetime[1];
				end_date_arr = end_date.split(".");
				end_day = parseInt(end_date_arr[0]);
				end_month = parseInt(end_date_arr[1]);
				end_year = parseInt(end_date_arr[2]);
				end_time_arr = end_time.split(":");
				end_hour = parseInt(end_time_arr[0]);
				end_min = parseInt(end_time_arr[1]);

				$.post("/booking", {user_id:user_id,court_id:court_id,at_day:start_day,at_month:start_month,at_year:start_year,at_hour:start_hour,at_min:start_min,to_day:end_day,to_month:end_month,to_year:end_year,to_hour:end_hour,to_min:end_min}, function(data){
					location.reload();
				});
			}
			else{
				alert_string = "Du musst Tabellenzellen anklicken, um diese für eine Buchung zu markieren!";
			}
		}
		else{
			alert_string = "Bitte erst einloggen";
		}
		if(alert_string != "") alert(alert_string);
	});
	$("#menue #mobile_menue_button").stop().click(function(){
		$("#menue #mobile_menue").stop().slideToggle(500);
	});
});