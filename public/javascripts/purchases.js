$('body').ready(function() {
  var signature = $('#new_purchase').data('signature')
  var ip_address = $('#new_purchase').data('ip_address')
  var shot_id = $('.purchase').find('.btn').data('shot_id')
  var stage_id = document.getElementById('image_id').value
  $('#shot_id').val(shot_id)
  $('#stage_id').val(stage_id)
  var subscription = {
    setupForm: function() {
      return $('#new_purchase').submit(function() {
        $('input[type=submit]').prop('disabled', true);
        if ($('#card_number').length) {
          subscription.processCard();
          return false;
        } else {
          return true;
        }
      });
    },
    processCard: function() {
      var plan;
      plan = {
        plan_code: $('#plan').val(),
      };
      var coupon;
      coupon = {
        coupon_code: $('#coupon').val(),
      };
      var card;
      card = {
        customer_id: $('#purchase_customer_id').val(),
        email: $('#purchase_email').val(),
        first_name: $('#purchase_first_name').val(),
        last_name: $('#purchase_last_name').val(),
        number: $('#card_number').val(),
        cvc: $('#card_code').val(),
        expMonth: $('#card_month').val(),
        expYear: $('#card_year').val(),
        country: $('#country').val(),
        ip_address: ip_address
      };
      return Recurly.Subscription.save(signature, plan, coupon, card, subscription.handleResponse);
    },
    handleResponse: function(response) {
      if(response.success) {
        $('#purchase_card_token').val(response.success.token)
        // $('#new_purchase')[0].submit(function (e) {
        //   e.preventDefault();
        //   return false;
        // });
            $('#new_purchase').ajaxSubmit({url: '/purchases.js', type: 'post'})
      }
      else if(response.errors) {
        $('#card_error').text(Recurly.flattenErrors(response.errors)).show();
        return $('input[type=submit]').prop('disabled', false);
      }
    }
  };
  return subscription.setupForm();
});
