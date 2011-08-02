// pick a background image based on what time of day it is
$(function() {
  var images = $('body').data('background_images');

  if(images === undefined) { return; }

  var currentHour = (new Date()).getHours();

  var set = [];

  var className = '';

  if(currentHour >= 6 && currentHour <= 11) {
    set = images.sunrise;
    className = 'sunrise';
  } else if (currentHour > 11 && currentHour <=  16) {
    set = images.mid_day;
    className = 'mid-day';
  } else if (currentHour >= 17 && currentHour <= 20) {
    set = images.sunset;
    className = 'sunset';
  } else {
    set = images.clubbing;
    className = 'clubbing';
  }

  var index = Math.floor(Math.random() * set.length);
  var css = "url('"+set[index]+"')";
  $('html').css('backgroundImage', css);
});
