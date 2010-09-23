var windowWidth = $(window).width();
$(window).resize(function(){
  windowWidth = $(window).width();
});

//add tooltips to the month calendar
var TT = {
  delay : 600,

  setTips : function() {
    $('[id^=day-cell]').each(function() {
      var date = /(?:day-cell)(\d+)/.exec($(this).attr('id'))[1];
      var assocRow = $('.row' + date);
      if (assocRow.children().length > 0) {
        $(this).removeAttr('title');
        var popupTable = $('<table class="popup"></table>');
        assocRow.clone(true).appendTo(popupTable);
        popupTable.appendTo($(this));
        var coords = $(this).offset();
        $(this).hover(function() {
          TT.current = $(this);
          TT.tip = TT.current.find('.popup');
          TT.timer = setTimeout(function() {
            TT.tip.css('top', coords.top + (0.5 * TT.current.outerHeight()));
            TT.leftCoord = coords.left + (0.5 * TT.current.outerWidth()) - ( 0.5 * TT.tip.outerWidth());
            if (TT.leftCoord < 50) { //if too far left
              TT.leftCoord = 50
            }
            if (TT.leftCoord + TT.tip.outerWidth() > windowWidth) { //if too far right
              TT.leftCoord = ( windowWidth - TT.tip.outerWidth())
            }
            TT.tip.css('left', TT.leftCoord);
            TT.tip.show(400);
          }, TT.delay);
        }, function() {
          clearTimeout(TT.timer);
          TT.tip.hide(400);
        })
      }
    });
    TT.popupHeader = $('table.trip-list tr:first').clone();
    TT.popupHeader.find('th:first').remove().end()//remove date from header
        .find('th:nth-child(5)').html('Vehicle').end();//shorten column name
    TT.popupHeader.prependTo('table.popup');
    $('.popup td.date-column').remove();
  }
};

$(document).ready(function() {
  // expand the title on page open
  $('#banner h1').css("fontSize", "6px");
  $('#banner h1').animate({fontSize:"28px"}, 1000);

  //set tooltips on month view
  TT.setTips();

  //create background blob for navbar
  $('<div id="nav-blob"></div>').css({
    width: $('#navigation li:first a').width() + 10,
    height: $('#navigation li:first a').height() + 20
  }).appendTo('#navbar').hide();

  $('#navbar a').hover(function() {
    // Mouse over function
    $('#nav-blob').animate(
    {width: $(this).width() + 10, left: $(this).position().left},
    {duration: 'slow', easing: 'easeOutElastic', queue: false}
        );
  }, function() {
    // Mouse out function
    var leftPosition = $('#navbar a:first').position().left;
    $('#nav-blob').animate(
    {width:'hide'},
    {duration:'slow', easing: 'easeOutCirc', queue:false}
        ).animate({left: leftPosition}, 'fast');
  });

  //add date picker to trip form
  $('#trip_date').datepicker({
  });

  //WIP accordion
  var openCloseDiv = function(openDiv, closeDiv) {
    if (openDiv != null) {
      openDiv.addClass('active').stop(true).animate({width: '450px'}, {queue:false, duration:400})
          .addClass('active').css({'text-align': 'center', 'background-color':'transparent'})
          .find('th.vehicle-header').css('font-size', 'x-small').end().find('span, a').show();
    }
    if (closeDiv != null) {
      closeDiv.removeClass('active').stop(true).animate({width: '45px'}, {queue:false, duration:400})
          .removeClass('active').css({'text-align': 'left', 'background-color': 'gray'})
          .find('th.vehicle-header').css('font-size', '0').end().find('span, a').hide();
    }
  };

  //start with current day open
  openCloseDiv(null, $("table#wip div[class^='col']"));
  var weekDayNum = new Date().getDay() + 1;
  openCloseDiv($("table#wip div.col" + weekDayNum), null);

  $('[class^=col]').hover(function() {
    if ($(this).hasClass('active')) {
      return  //do nothing when over open div
    }
    var currentDiv = $(this);
    currentDiv.addClass('waiting');
    setTimeout(function() {
      if (currentDiv.hasClass('waiting')) {
        openCloseDiv(currentDiv, $('table#wip div.active'));
        currentDiv.removeClass('waiting');
      }
    }, 400)
  },
                         function() {
                           $(this).removeClass('waiting')
                         }
      );

  //have only every 4th row border solid in WIP table
  $('table#wip table').each(function() {
    $(this).find('tr').each(function(i) {
      if ((i + 3) % 4 == 0) {
        $(this).css("border-bottom", "1px solid black")
      }
    })
  })

});

