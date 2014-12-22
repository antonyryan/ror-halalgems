# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery-ui/autocomplete

$(document).ready ->
	$('[data-toggle="offcanvas"]').click ->
		$('.row-offcanvas').toggleClass('active')   
$(document).ready ->
	$('#Neighborhood').autocomplete
		source: '/neighborhoods/index.json',
		minLength: 2,
		select: ( event, ui ) ->
			if ui.item
				$('#listing_neighborhood_id').val(ui.item.id);
map = null
geocoder = null

$(document).ready ->
	mapCanvas = $('#map-canvas');
	mapOptions = 
		center: new google.maps.LatLng 44.5403, -78.5463 
		zoom: 16,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	map = new google.maps.Map $('#map-canvas')[0], mapOptions
	geocoder = new google.maps.Geocoder
	codeAddress()

codeAddress = -> 
	address = $('#address').text()	
	geocoder.geocode 'address': address, (results, status) ->
    	if status is google.maps.GeocoderStatus.OK 
      		map.setCenter results[0].geometry.location
      		marker = new google.maps.Marker
          		map: map,
          		position: results[0].geometry.location      
    	 else 
      		alert('Geocode was not successful for the following reason: ' + status)
