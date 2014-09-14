// Generated by CoffeeScript 1.6.3
(function() {
  $(function() {
    var $upperMenu, $upperMenuItems, $upperPanel;
    $("#instructions-slider").slidesjs({
      width: 720,
      height: 470,
      navigation: false,
      pagination: {
        effect: "fade"
      },
      effect: {
        fade: {
          speed: 800,
          crossfade: true
        }
      }
    });
    $upperPanel = $('.frontpage-upper-panel');
    $upperMenu = $('.upper-menu');
    $upperMenuItems = $('.upper-menu-item');
    $(window).scroll(function() {
      var scrolled;
      scrolled = $(window).scrollTop();
      return $('.content-block').each(function() {
        var thisId;
        if (scrolled + $upperPanel.outerHeight() > $(this).position().top) {
          thisId = this.id;
          $upperMenuItems.removeClass('active');
          return $upperMenuItems.each(function() {
            if ($(this).data('destination') === thisId) {
              return $(this).addClass('active');
            }
          });
        }
      });
    });
    return $upperMenuItems.click(function(event) {
      var destination;
      if ($(this).hasClass('active')) {
        return false;
      }
      destination = $(this).data('destination');
      return $('html, body').stop().animate({
        scrollTop: document.getElementById(destination).offsetTop - $upperPanel.outerHeight() + 15
      }, 2000, 'easeInOutExpo');
    });
  });

}).call(this);

/*
//@ sourceMappingURL=init.map
*/
