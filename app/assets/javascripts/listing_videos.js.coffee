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
  clodinaryFileUpload = $(".cloudinary-fileupload:eq(2)")
  if clodinaryFileUpload.length > 0
    clodinaryFileUpload.cloudinary_fileupload()
    clodinaryFileUpload.bind 'fileuploadprogress', (e, data) ->
      if data.context
        percents =parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.progress-bar').css('width', percents+'%').attr('aria-valuenow', percents);
      return

    clodinaryFileUpload.bind 'fileuploadfail', (e, data) ->
      $(".status").text("Upload failed")

    clodinaryFileUpload.off("fileuploadsend").on("fileuploadsend", (e, data) ->
      videos_container = $('#videos')
      common_fields = $(this).data('fields')

      time_for_id = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')

      videos_container.append(common_fields.replace(regexp, time_for_id))

      progressDiv = $('<div/>').addClass('progress').append($('<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"/>'))
      progressDiv.data('id', time_for_id)
      data.context=progressDiv.prependTo(videos_container.find(".thumbnail:last"))
    )

    clodinaryFileUpload.off("cloudinarydone").on("cloudinarydone", (e, data) ->
      row = $('#videos')
      time = data.context.data('id')
      data.context.parent().find('video').remove()
      $($.cloudinary.video(data.result.public_id)).prependTo(data.context.parent())
      data.context.remove()

      upload_info = [data.result.resource_type, data.result.type, data.result.path].join("/") + "#" + data.result.signature;
      $('<input/>').attr({type: "hidden", name: 'listing[property_videos_attributes]['+time+'][video_url]'}).val(upload_info).appendTo(data.form)
      return)
  return

view_upload_details = (upload) ->
  rows = [];
  $.each(upload, (k,v) ->
    rows.push($("<tr>").append($("<td>").text(k)).append($("<td>").text(JSON.stringify(v))))
    return)

  $("#info").html($("<div class=\"upload_details\">").append("<h2>Upload metadata:</h2>").append($("<table>").append(rows)))
  return