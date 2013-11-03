//= require jquery
//= require_self

jQuery(document).ready(function($) {

  /* Login */
  var $loginForm = $('.login-wrap form');
  if ($loginForm.length) {
    $loginForm.find('[name="email"]').focus();
  }

});