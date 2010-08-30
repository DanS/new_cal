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

  //add date picker
  $('#trip_date').datepicker({
  });

});