//= require underscore-min
//= require_self

/* Apply to a bootcamp */

$.getJSON(cardUpdatePath, function(application) {

  // Add proper classes to bootcamps that have been applied to
  for (var i = 0; i < application['bootcamp_selections'].length; i++) {
    var bootcampId = application['bootcamp_selections'][i].bootcamp_id;
    $('.btn--apply[data-bootcamp="' + bootcampId + '"]').removeClass('apply').addClass('applied');
  }

  window.application = application;

  $(document).on('click', '.btn--apply', function(e) {
    e.stopPropagation();
    e.preventDefault();

    var $this = $(this),
        bootcampId = $this.data('bootcamp');

    if ($this.hasClass('applying') || $this.hasClass('removing')) {
      return false;
    }

    var classToRemove = '',
        classToAdd = '',
        selections = window.application['bootcamp_selections'];

    // Remove bootcamp 
    if ($this.hasClass('applied')) {
      classToRemove = 'removing';
      classToAdd = 'apply';
      selections = _.filter(selections, function(s) {
        return s.bootcamp_id != bootcampId;
      });
      selections = _.sortBy(selections, function(s) {
        return s.priority;
      });
      var i = 1;
      selections = _.map(selections, function(s) {
        s.priority = i;
        i++;
        return s;
      });
    }
    // Add bootcamp
    else {
      classToRemove = 'applying';
      classToAdd = 'applied';
      selections.push({
        'priority': selections.length + 1,
        'bootcamp_id': bootcampId
      });
    }

    window.application['bootcamp_selections'] = selections;
    $this.removeClass('apply removing applied applying').addClass(classToRemove);

    $.ajax({
      url: cardUpdatePath,
      type: 'PATCH',
      data: {
        'bootcamp_selections': selections
      }
    }).done(function(result) {
      if (result && !result['error']) {
        $this.removeClass('apply removing applied applying').addClass(classToAdd);
      }
    });

  });

});