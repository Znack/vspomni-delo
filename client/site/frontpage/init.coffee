detectExtension = require('../common.js').detectExtension

$(()->
  $("#instructions-slider").slidesjs({
    width: 720,
    height: 500,
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

  detectExtension((err, success)->
    return null if err?
    $('.extension-link-block .extension-link').text("Установлено").addClass('disable')
  )
)