var regions = new Array('billing', 'shipping', 'shipping_method', 'creditcard', 'confirm_order');

$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

// public/javascripts/application.js
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.change(function() {
    $.post('select_country', $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.sameAddress = function() {
  this.click(function() {
    if(!$(this).attr('checked')) {
      //Clear ship values?
      return;
    }
    $('span#scountry select').val($('span#bcountry select').val());
    update_state('s');
    $("#billing input, #billing select").each(function() {
      $("#shipping #"+ $(this).attr('id').replace('bill', 'ship')).val($(this).val());
    })
    //For some reason this isn't getting picked up from above.. Debug later
    $('#sstate :child').val($('#bstate :child').val());
  })
}

//On page load
$(function() {  
  //$("#checkout_presenter_bill_address_country_id").submitWithAjax();  
  $('#checkout_presenter_same_address').sameAddress();
  $('span#bcountry select').change(function() { update_state('b'); });
  $('span#scountry select').change(function() { update_state('s'); });
  get_states();

  $('div#validate_billing').click(function() { if(validate_section('billing')) { submit_billing(); }});
  $('div#validate_shipping').click(function() { if(validate_section('shipping')) { submit_shipping(); }});
  $('div#select_shipping_method').click(function() { submit_shipping_method(); });  
  $('div#confirm_payment').click(function() { if(validate_section('creditcard')) { confirm_payment(); }}); 
})

//Initial state mapper on page load
var state_mapper;
var get_states = function() {
  $.getJSON('/javascripts/states.js', function(json) {
    state_mapper = json;
    $('span#bcountry select').val($('[name=submit_bcountry]').val());
    update_state('b');
    $('span#bstate :child').val($('[name=submit_bstate]').val());
    $('span#scountry select').val($('[name=submit_scountry]').val());
    update_state('s');
    $('span#sstate :child').val($('[name=submit_sstate]').val());
  });
};

//Update state input / select
var update_state = function(region) {
  var name = $('span#' + region + 'state :child').attr('name');
  var id = $('span#' + region + 'state :child').attr('id');
  $('span#' + region + 'state :child').remove();
  var match;
  var selected = $('span#' + region + 'country :child :selected').html()
  $.each(state_mapper.maps, function(i, item) {
    if(selected == item.country) {
      match = item.states;
    }
  });
  if(match) {
    $('span#' + region + 'state').append($(document.createElement('select')));
    $.each(match, function(i, item) {
      $('span#' + region + 'state select').append($(document.createElement('option')).attr('value', item.value).html(item.text));
    });
  } else {
    $('span#' + region + 'state').append($(document.createElement('input')));
  }
  $('span#' + region + 'state select, span#' + region + 'state input').addClass('required').attr('name', name).attr('id', id);
};

var validate_section = function(region) {
  var validator = $('form#checkout_form').validate();
  var valid = true;
  $('div#' + region + ' input, div#' + region + ' select, div#' + region + ' textarea').each(function() {
    if(!validator.element(this)) {
      valid = false;
    }
  });
  return valid;
};

var shift_to_region = function(active) {
  var found = 0;
  for(var i=0; i<regions.length; i++) {
    if(!found) {
      if(active == regions[i]) {
        $('div#' + regions[i] + ' h2').unbind('click').css('cursor', 'default');
        $('div#' + regions[i] + ' div.inner').show();
        found = 1;
      }
      else {
        $('div#' + regions[i] + ' h2').unbind('click').css('cursor', 'pointer').click(function() {shift_to_region($(this).parent().attr('id'));});
        $('div#' + regions[i] + ' div.inner').hide();
        $('div#' + regions[i]).removeClass('checkout_disabled');
      }
    } else {
      $('div#' + regions[i] + ' h2').unbind('click').css('cursor', 'default');
      $('div#' + regions[i] + ' div.inner').hide();
      $('div#' + regions[i]).addClass('checkout_disabled');
    }
  }
  return;
};

var submit_billing = function() {
  shift_to_region('shipping');
  return;
};
var submit_shipping = function() {
  shift_to_region('shipping_method');
  return;
};
                     
var submit_shipping_method = function() {
  shift_to_region('creditcard');
};

var confirm_payment = function() {
  shift_to_region('confirm_order');
};
