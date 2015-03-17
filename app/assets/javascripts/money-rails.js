
$(document).ready(function() {
  money_fields = $('.currency')
  money_fields.autoNumeric('init', {aSep: '.',  aDec: ','});
  $(document).keypress(function(event) {
    if(event.which == 13) {
      money_fields.autoNumeric('set', money_fields.autoNumeric('get'))
    }
  });
});