# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery-ui/autocomplete
#= require jquery.jcarousel.min
#= require listing_photos

$(document).ready ->
  $('[data-toggle="offcanvas"]').click ->
    $('.row-offcanvas').toggleClass('active')

#carousel
#todo: Add responsiveness http://sorgalla.com/jcarousel/docs/cookbook/responsive-carousel.html
$(document).ready ->
  # This is the connector function.
  # It connects one item from the navigation carousel to one item from the
  # stage carousel.
  # The default behaviour is, to connect items with the same index from both
  # carousels. This might _not_ work with circular carousels!
  connector = (itemNavigation, carouselStage) ->
    return carouselStage.jcarousel('items').eq(itemNavigation.index());

  $ ->
    # Setup the carousels. Adjust the options for both carousels here.
    carouselStage = $('.carousel-stage')
    .on 'jcarousel:create jcarousel:reload', ->
      element = $(this)
      width = element.innerWidth()
      height = element.innerHeight()
      element.jcarousel('items').css('width', width + 'px')
      element.jcarousel('items').css('height', height + 'px')
      return
    .jcarousel()
    carouselNavigation = $('.carousel-navigation').jcarousel()

    # We loop through the items of the navigation carousel and set it up
    # as a control for an item from the stage carousel.
    carouselNavigation.jcarousel('items').each(->
      item = $(this)

      # This is where we actually connect to items.
      target = connector(item, carouselStage);

      item
      .on 'jcarouselcontrol:active', ->
        carouselNavigation.jcarousel('scrollIntoView', this)
        item.addClass('active')
        return
      .on 'jcarouselcontrol:inactive', ->
        item.removeClass('active')
        return
      .jcarouselControl
          target: target,
          carousel: carouselStage
      return
    )
    # Setup controls for the stage carousel
    $('.prev-stage')
    .on 'jcarouselcontrol:inactive', ->
      $(this).addClass('inactive')
      return

    .on 'jcarouselcontrol:active', ->
      $(this).removeClass('inactive')
      return

    .jcarouselControl
        target: '-=1'


    $('.next-stage')
    .on 'jcarouselcontrol:inactive', ->
      $(this).addClass('inactive')
      return

    .on 'jcarouselcontrol:active', ->
      $(this).removeClass('inactive')
      return

    .jcarouselControl
        target: '+=1'


    # Setup controls for the navigation carousel
    $('.prev-navigation')
    .on 'jcarouselcontrol:inactive', ->
      $(this).addClass('inactive')
      return

    .on 'jcarouselcontrol:active', ->
      $(this).removeClass('inactive');
      return

    .jcarouselControl
        target: '-=1'


    $('.next-navigation')
    .on 'jcarouselcontrol:inactive', ->
      $(this).addClass('inactive')
      return

    .on 'jcarouselcontrol:active', ->
      $(this).removeClass('inactive')
      return

    .jcarouselControl
        target: '+=1'
    return
  return

split = (val) ->
  val.split(/,\s*/)
extractLast = (term) ->
  split(term).pop()

$(document).ready ->
  $("#neighborhood_ids").tokenInput "/neighborhoods/index.json",
    crossDomain: false
    queryParam: "term"
    prePopulate: $("#neighborhood_ids").data('pre')
    theme: "facebook"
#    allowFreeTagging: true
#    tokenValue: "name"

$(document).ready ->
  $('#city_name').autocomplete
    source: '/cities/index.json',
    minLength: 2,
    select: (event, ui) ->
      if ui.item
        $('#listing_city_id').val(ui.item.id);

map = null
geocoder = null

$(document).ready ->
  if $('#map-canvas').length
    mapCanvas = $('#map-canvas');
    mapOptions =
      center: new google.maps.LatLng 44.5403, -78.5463
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map $('#map-canvas')[0], mapOptions
    geocoder = new google.maps.Geocoder
    codeAddress()
    return

codeAddress = ->
  address = $('#address').data("value")
  geocoder.geocode 'address': address, (results, status) ->
    if status is google.maps.GeocoderStatus.OK
      map.setCenter results[0].geometry.location
      marker = new google.maps.Marker
        map: map,
        position: results[0].geometry.location
    else
      alert('Geocode was not successful for the following reason: ' + status)
    return
  return

jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('#myModal').on 'show.bs.modal', (event) ->
    selected = []
    c = 0
    $('#listings_from input:checked').each () ->
      field = $('<input name="listing_ids[]" id="listing_ids_" type="hidden">').val($(this).val())
      form = $('#send_email_form')
      form.append(field)
      c = c + 1

    if c == 0
      event.preventDefault()
      $("div.alert").remove();
      alertErr = $('<div class="alert alert-error">Selection is empty</div>');
      $('#mainContainer').prepend(alertErr)

    $('#myModal').on 'shown.bs.modal', (event) ->
      $('#email').focus()

jQuery ->
  $('#send').click ->
    formValid = true
    $('input').each ->
      formGroup = $(this).parents('.form-group')
      glyphicon = formGroup.find('.form-control-feedback')
      if this.checkValidity()
        formGroup.addClass('has-success').removeClass('has-error')
        glyphicon.addClass('glyphicon-ok').removeClass('glyphicon-remove')
      else
        formGroup.addClass('has-error').removeClass('has-success')
        glyphicon.addClass('glyphicon-remove').removeClass('glyphicon-ok')
        formValid = false
    if formValid
      $('#myModal').modal('hide')
      $('#send_email_form').submit()

jQuery ->
  $.each(['show', 'hide'], (i, ev) ->
    el = $.fn[ev];
    $.fn[ev] = () ->
      this.trigger(ev);
      el.apply(this, arguments);
  )

  taxesCheckBox = $('#listing_taxes_included')
  $('#listing_taxes_amount').prop('disabled', !taxesCheckBox.is(':checked'))

  taxesCheckBox.change ->
    $('#listing_taxes_amount').prop('disabled', !this.checked)

  $('#narrow_button').click ->
    event.preventDefault()
    form = $('#filter_form')
    c = 0
    $('#listings_from input:checked').each ->
      field = $('<input name="ids[]" id="ids_" type="hidden">').val($(this).val())
      form.append(field)
      c = c + 1

    if c != 0
      form.submit()

  property_type_input = $('#listing_property_type_id')
  property_type_input.change (event) ->
    if $('#listing_property_type_id option:selected').text() == 'Coop'
      $('#taxes_div').hide()
      $('#maintenance_div').show()
    else
      $('#taxes_div').show()
      $('#maintenance_div').hide()
      
    if $('#listing_property_type_id option:selected').text() != 'Condo'
      $('#charges_div').hide()
      $('#tax_abatement_div').hide()
    else
      $('#charges_div').show()
      $('#tax_abatement_div').show()

  $('#listing_status_id').change (event) ->
    if jQuery.inArray( $('#listing_status_id option:selected').text(), ['Rented', 'Deposit/Pending Application', 'Accepted offer', 'Under contract', 'Closed']) != -1
      $('#action_user_div').show()
    else
      $('#action_user_div').hide()
      $('#listing_action_user_id').val('')