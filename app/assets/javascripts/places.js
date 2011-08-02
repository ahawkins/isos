$(function() {
  if($('#map').length == 0) { return; }

  var center = new google.maps.LatLng(33.28462, -39.550781);

  var map = new google.maps.Map($('#map')[0], {
    zoom: 3,
    minZoom: 3,
    center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDefaultUI: true
  });

  $.each(ISOS.posts.reverse(), function(i, post) {
    if(post.location.latitude == null && post.location.longitude == null) {
      return;
    }

    setTimeout(function() {
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(post.location.latitude, post.location.longitude),
        map: map,
        post: post,
        animation: google.maps.Animation.DROP
      });

      if(post.picture) {
        google.maps.event.addListener(marker, 'click', function() {
          $('#overlay').addClass('visible');
          $('#post_'+post['_id']).addClass('visible');
        });
      };

      google.maps.event.addListener(marker, 'mouseover', function() {
        $('#popup_post_'+post['_id']).addClass('visible');
      });
      google.maps.event.addListener(marker, 'mouseout', function() {
        $('#popup_post_'+post['_id']).removeClass('visible');
      });
    }, i * 200);
  });

  $('#overlay, .post').live('click', function() {
    $('.post').removeClass('visible');
    $('#overlay').removeClass('visible');
  });
});
