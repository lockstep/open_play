var googlePlaceApi = (function() {
  var getAttributesFromGeocoded_data = function(geocode_results) {
    var result = {};
    $.each(geocode_results, function() {
      switch(this.types[0]) {
        case 'locality':
          result.city = this.long_name;
          break;
        case 'administrative_area_level_1':
          result.state = this.long_name;
          break;
       case 'postal_code':
          result.zip = this.long_name;
          break;
        case 'country':
          result.country = this.long_name;
          break;
      }
    });
    return result;
  };

  var setBusinessLocation = function(geocode_results) {
    geocoded_data = getAttributesFromGeocoded_data(geocode_results)
    $('#business_city').val(geocoded_data.city);
    $('#business_state').val(geocoded_data.state)
    $('#business_zip').val(geocoded_data.zip);
    $('#business_country').val(geocoded_data.country);
  };

  var isBusinessType = function() {
    return $('#business_city').length > 0;
  };

  return {
    loadGooglePlacesScript: function(key, body, callback) {
      var script = document.createElement('script');
      script.type = 'text/javascript';
      script.src = 'https://maps.googleapis.com/maps/api/js?key=' + key +
                  '&libraries=places&callback=' + callback
      script.async = true;
      script.defer = true;
      body.appendChild(script);
      return;
    },

    initGooglePlacesAutocomplete: function() {
      var input = document.getElementsByClassName('autocomplete-places')[0]
      var options = { types: ['establishment'] }
      var autocomplete = new google.maps.places.Autocomplete(input, options);
      google.maps.event.addListener(autocomplete, 'place_changed', function() {
        var place = autocomplete.getPlace();
        if (!place.geometry) {
          return;
        } else {
          $('.place_latitude').val(place.geometry.location.lat());
          $('.place_longitude').val(place.geometry.location.lng());
          if (isBusinessType() === true) {
            setBusinessLocation(place.address_components)
          } else {
            $('.place_address').val(place.formatted_address);
          }
        }
      });
    }
  }
}());

$(function() {
  if ($('.autocomplete-places').length > 0) {
    var key = $('.autocomplete-places').data('key');
    var callback = 'googlePlaceApi.initGooglePlacesAutocomplete';
    googlePlaceApi.loadGooglePlacesScript(key, document.body, callback);
  }
});
