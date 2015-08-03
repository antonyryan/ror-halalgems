# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  data = $("#plot").data("var")
  tmpArr = $.makeArray(data)
  aticks = $.map tmpArr, (val, i) ->
    [[val.data[0][0] + 0.5, val.label]]


  options = {
    series: {
      bars: {
        show: true,
        barWidth: 1
      }
    },
    xaxis: {
      minTickSize: 1,
      ticks: aticks
    },
    yaxis: {
      minTickSize: 1
    },
    grid: {
      hoverable: true
    },
    legend: {
      show: false
    },
#    tooltip: true,
#    tooltipOpts: {
#      content: "date:%x, total: %y"
#    }
  };
  
  pieoptions = {
    series: {
      pie: {
        show: true
      }
    },
    grid: {
      hoverable: true
    },
    tooltip: true,
    tooltipOpts: {
      content: "%p.0%, %s",
      shifts: {
        x: 20,
        y: 0
      },
      defaultTheme: false
    }
  }

  $.plot($("#plot"), data, options);