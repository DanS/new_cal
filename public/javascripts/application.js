var windowWidth = $(window).width();
$(window).resize(function() {
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
    TT.popupHeader.find('th:nth-child(6)').html('Vehicle').end();//shorten column name
    TT.popupHeader.prependTo('table.popup');
  }
};

var showOnly = function(letter, dest) {
  showAll();
  //set 'showing to' title
  $('span#showing-dest').html(dest);
  //month calendar
  $('table.calendar [id^=day-cell]').each(function(i, e) { //iterate thru all calendar days
    var fullClass = null;
    var match = null;
    if (fullClass = $(e).attr('class')) {//if day has a class
      if (match = /(?:\s)([A-Z]+)/.exec(fullClass)) { // if class has a destination element
        var colorClass = match[1];
        if (colorClass) {
          $(e).removeClass(colorClass).data('colorClass', colorClass);
          var re = new RegExp(letter);
          if (re.exec(colorClass)) {
            $(e).addClass(letter);
            $(e).data('temp', letter)
          }
        }
      }
    }
  });
  // week calendar
  $('table.day td.week-trip').each(function(i, e) {
    if (! $(e).hasClass(letter)) {
      $(e).hide()
    }
  });
  //trip-list
  $('table.trip-list tr.trip').each(function(i, e) {
    if ($(e).find('td:nth-child(3)').attr('class') != letter) {
      $(e).hide()
    }
  })
};

var showAll = function() {
  //title
  $('span#showing-dest').html('Everywhere');
  //month calendar
  $('table.calendar [id^=day-cell]').each(function(i, e) {
    var temp = $(e).data('temp');
    if (temp) {
      $(e).removeClass(temp).removeData('temp');
    }
    var colorClass = $(this).data('colorClass');
    if (colorClass) {
      $(this).addClass(colorClass);
    }
  });
  // week calendar
  $('table.day td.week-trip').show();
  //trip-list
  $('table.trip-list tr.trip').show();
};

var setTripListWidth = function() {
  var width = $('table.calendar:first').outerWidth(true) * 3 + $('table#destination-list').outerWidth(true);
  width = width > 500 ? width : 1000; //ensure width set on week view
  $('table.trip-list').css("width", width);
}

$(document).ready(function() {
  // expand the title on page open
  $('#banner h1').css("fontSize", "6px");
  $('#banner h1').animate({fontSize:"28px"}, 1000);

  //set tooltips on month view
  TT.setTips();

  //add date picker to trip form
  Date.firstDayOfWeek = 0;
  Date.format = 'mm/dd/yyyy';
  $('#trip_date').datepicker();

  //set click action on destination list
  $('table#destination-list a').css('text-decoration', 'none').click(function(e) {
    e.preventDefault();
  });
  $('table#destination-list td').each(function(i, e) {
    var letter = $(this).attr('class');
    var dest = $(this).find('a span').html();
    var that = $(this)
    $(this).click(function() {
      $('table#destination-list td a').removeClass('selected');
      that.find('a').addClass('selected');
      showOnly(letter, dest);
    });
    $('table#destination-list tr:last').click(function() {
      showAll(letter);
    });
    
    setTripListWidth();
  });

  //WIP accordion
  var openCloseDiv = function(openDiv, closeDiv) {
    if (openDiv != null) {
      openDiv.addClass('active').stop(true).animate({width: '450px'}, {queue:false, duration:400})
          .addClass('active').css({'text-align': 'center', 'background-color':'transparent'})
          .find('th.vehicle-header').css('font-size', 'x-small').end().find('span, a').show();
    }
    if (closeDiv != null) {
      $.each(closeDiv, function(i, colDiv) {
        var divWidth = $(colDiv).find('.time-header').length > 0 ? '100px' : '45px'
        $(colDiv).removeClass('active').stop(true).animate({width: divWidth}, {queue:false, duration:400})
            .removeClass('active').css({'text-align': 'left', 'background-color': 'gray'})
            .find('th.vehicle-header').css('font-size', '0').end().find('span, a').hide();
      });
      $('.hour, .time-header').css({'background-color': 'white'});
    }
  };

  //start with current day open
  openCloseDiv(null, $("table#wip div[class^='col']"));
  var weekDayNum = new Date().getDay() + 1;
  openCloseDiv($("table#wip div.col" + weekDayNum), null);

  $('[class^=col]').hover(function() {
    if ($(this).hasClass('active')) {
      return;  //do nothing when over open div
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
                         });
  //have only every 4th row border solid in WIP table
  $('table#wip table').each(function() {
    $(this).find('tr').each(function(i) {
      if ((i + 3) % 4 == 0) {
        $(this).css("border-bottom", "1px solid black")
      }
    })
  })

});

