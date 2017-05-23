#= require cloudinary

#jQuery ->
#  $("#upload_widget_opener").on "click", () ->
#    cloudinary.openUploadWidget({
#        cloud_name: 'hpmowmbqq',
#        upload_preset: 'oldzpjbf', form: '#new_listing',
#        field_name: 'listing[property_videos_attributes][][video_url]'
#        thumbnails: '#videos'
#      },
#    (error, result) ->
#      console.log(error, result)
#    )

jQuery ->
  $("#check_url").on "click", () ->
    url = $(this).parent().find('input[name="video_url"]').val();
    if (url != undefined || url != '') 
      regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=|\?v=)([^#\&\?]*).*/;
      match = url.match(regExp);
      if (match && match[2].length == 11)
        $(this).parent().find('#video_error').hide();
        $(this).parent().find('#show_video').attr('src',url);
        $(this).parent().find('#show_video').show();
        
      else 
        $(this).parent().find('#video_error').show();
        
    else
      $(this).parent().find('#video_error').show();
    


  
    


