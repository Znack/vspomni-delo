$(()->
  $("#instructions-slider").slidesjs({
    width: 720,
    height: 295,
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

  $upperPanel = $('.frontpage-upper-panel')
  $upperMenu = $('.upper-menu')
  $upperMenuItems = $('.upper-menu-item')
  $(window).scroll ()->
    scrolled = $(window).scrollTop();
    $('.content-block').each(()->
      if scrolled + $upperPanel.outerHeight() > $(this).position().top
        thisId = this.id
        $upperMenuItems.removeClass('active')
        $upperMenuItems.each(()->
          if $(this).data('destination') == thisId
            $(this).addClass('active')
        )
    )

  $upperMenuItems.click (event)->
    return false if $(this).hasClass('active')
    destination = $(this).data('destination');
    $('html, body').stop().animate(
      {
        scrollTop: document.getElementById(destination).offsetTop - $upperPanel.outerHeight() + 15
      }, 2000,'easeInOutExpo')
)