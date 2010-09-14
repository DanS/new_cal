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
  var openCloseDiv = function(openDiv, closeDiv) {
    if (openDiv != null) {
      openDiv.addClass('active').stop(true).animate({width: '355px'}, {queue:false, duration:400})
            .addClass('active').css({'text-align': 'center', 'background-color':'transparent'})
            .find('th.vehicle-header').css('font-size', 'xx-small').end().find('span, a').show();
    }
    if (closeDiv != null) {
      closeDiv.removeClass('active').stop(true).animate({width: '35px'}, {queue:false, duration:400})
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
     }, 400)},
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