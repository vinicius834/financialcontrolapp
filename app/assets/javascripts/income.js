$(document).ready(function() {
  $(".delete_income_link").click(function(event){
    event.preventDefault();
    if(confirm("Are you sure?")) {
      var url = $(this).attr("href");
      $.post(url, {_method: "delete"}).done(function(data){
        location.reload(true);
      });
    }
  });
    
  $("#income_filter_button").click(function(){
    var url = "";
    var from_date = $("#input_income_from_date").val();
    var to_date = $("#input_income_to_date").val();
      
    if (new Date(from_date) > new Date(to_date)) {
      alert("The from date cannot be less than to date.");
      ("#input_income_from_date").focus();
      return;
    }
    
    if(from_date == "" && to_date == "") { 
      alert("Fill out at least one date field.");
      $("#input_income_from_date").focus();
      return;
    }
    
    url = "incomes/search_between_dates/"
    
    $.get(url, { from_date_income: from_date, to_date_income: to_date }, function(result) {
      $(".income_list_content").html(result);
    });
  });
    
  $("#all_incomes_link").click(function(){
    var url = "incomes/all";
    $.get(url, function(result) {
      $(".income_list_content").html(result);
      $("#input_income_from_date").val('');
      $("#input_income_to_date").val('');
    });
  });
});