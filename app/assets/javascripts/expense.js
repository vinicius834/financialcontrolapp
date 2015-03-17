$( document ).ready(function() {
  $(".delete_expense_link").click(function(event){
    event.preventDefault();
    if(confirm("Are you sure?")) {
      var url = $(this).attr("href");
      $.post(url, {_method: "delete"}).done(function(data){
        location.reload(true);
      });
    }
  });

  $("#expense_filter_button").click(function(){
    var url = "";
    var from_date = $("#input_expense_from_date").val();
    var to_date = $("#input_expense_to_date").val();
      
    if (new Date(from_date) > new Date(to_date)) {
      alert("The from date cannot be less than to date.");
      ("#input_expense_from_date").focus();
      return;
    }
      
   if(from_date == '' && to_date == '') { 
      alert("Fill out at least one date field.");
      $("#input_expense_from_date").focus();
      return;
    }
      
    url = "expenses/search_between_dates/"
    
    $.get(url, { from_date_expense: from_date , to_date_expense: to_date }, function(result) {
      $(".expense_list_content").html(result);
    });
  });
    
  $("#all_expenses_link").click(function(){
    var url = "expenses/all";
    $.get(url, function(result) {
      $(".expense_list_content").html(result);
      $("#input_expense_from_date").val('');
      $("#input_expense_to_date").val('');
    });
  });
});