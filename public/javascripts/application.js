// expand the title on page open
$(document).ready(function() {
  $('#banner h1').css("fontSize", "6px");
  $('#banner h1').animate({fontSize:"28px"}, 1000);

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
  var openDiv = function(div){
    div.addClass('active').stop(true).animate({width: '355px'}, {queue:false, duration:400})
            .addClass('active').css('text-align', 'center').find('span').show();
  };

  var closeDiv = function(div){
    div.removeClass('active').stop(true).animate({width: '40px'}, {queue:false, duration:400})
      .removeClass('active').css('text-align', 'left').find('span').hide();
  };

  closeDiv($("table#wip div[class^='col']"));
  var weekDayNum = new Date().getDay() + 1;
  openDiv($("table#wip div.col" + weekDayNum));

  var openLeft = function() {
    var colNumber = parseInt(/(?:col)(\d+)/.exec($('table#wip div.active').attr('class'))[1]);
    if (colNumber > 1) {
      closeDiv($('.col' + colNumber));
      openDiv($('.col' + --colNumber));
    }
  };

  var openRight = function() {
    var colNumber = parseInt(/(?:col)(\d+)/.exec($('div.active').attr('class'))[1]);
    if (colNumber < 10) {
      closeDiv($('.col' + colNumber));
      openDiv($('.col' + ++colNumber));
    }
  };

  $('[class^=col]').hover(function() {
    var activeCol = parseInt(/(?:col)(\d+)/.exec($('div.active').attr('class'))[1]);
    var thisCol = parseInt(/(?:col)(\d+)/.exec(this.className)[1]);
    if($(this).hasClass('active')){return} //do nothing when over open div
    var currentDiv = $(this);
    currentDiv.addClass('waiting');
    setTimeout(function() {
      if (currentDiv.hasClass('waiting')) {
        if (activeCol < thisCol) {
          openRight();
        } else {
          openLeft();
        }
        currentDiv.removeClass('waiting');
      }
    }, 600)
  },
    function() {
      $(this).removeClass('waiting')
    }
  )

});