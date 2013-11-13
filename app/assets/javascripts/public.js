//= require jquery
//= require_self

jQuery(document).ready(function($) {

  /* Me Dropdown */
  $(document).on('click', '.js-me', function(e) {
    e.preventDefault();
    e.stopPropagation();

    $(this).parent().toggleClass('active');
    $(this).find('.dropdown').on('click', function(e) {
      e.stopPropagation();
    });
  });

  $(document).on('click', function(e) {
    $('.js-dropdown-wrap').removeClass('active');
  });

  /* Adjust footer height */
  $(window).on('load', function() {
    var $footer = $('.site-footer'),
        footerHeight = $('.site-footer').outerHeight();
    $footer.css({
      'margin-top': -footerHeight,
      'height': footerHeight
    });
    $('.site-content').css('padding-bottom', footerHeight);
  });

  /* Flash */
  var $flash = $('.flash');
  if ($flash.length) {
    $('body').addClass('has-flash');
    $flash.addClass('enabled');

    setTimeout(function() {
      $flash.removeClass('enabled');
      $('body').removeClass('has-flash');
    }, 5000);
  }

  window.setFlash = function(type, content) {
    
  }

  window.swapNodes = function(a, b) {
    var aparent= a.parentNode;
    var asibling= a.nextSibling===b? a : a.nextSibling;
    b.parentNode.insertBefore(a, b);
    aparent.insertBefore(b, asibling);
  }
  
});
