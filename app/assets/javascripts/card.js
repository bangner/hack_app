//= require underscore-min
//= require_self

/* Apply to a school */

$.getJSON(cardUpdatePath, function(application) {

  // Add proper classes to schools that have been applied to
  for (var i = 0; i < application['school_selections'].length; i++) {
    var schoolId = application['school_selections'][i].school_id;
    $('.btn--apply[data-school="' + schoolId + '"]').removeClass('apply').addClass('applied');
  }

  window.application = application;

  $(document).on('click', '.btn--apply', function(e) {
    e.stopPropagation();
    e.preventDefault();

    var $this = $(this),
        schoolId = $this.data('school');

    if ($this.hasClass('applying') || $this.hasClass('removing')) {
      return false;
    }

    var classToRemove = '',
        classToAdd = '',
        selections = window.application['school_selections'];

    // Remove school 
    if ($this.hasClass('applied')) {
      classToRemove = 'removing';
      classToAdd = 'apply';
      selections = _.filter(selections, function(s) {
        return s.school_id != schoolId;
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
    // Add school
    else {
      classToRemove = 'applying';
      classToAdd = 'applied';
      selections.push({
        'priority': selections.length + 1,
        'school_id': schoolId
      });
    }

    window.application['school_selections'] = selections;
    $this.removeClass('apply removing applied applying').addClass(classToRemove);

    $.ajax({
      url: cardUpdatePath,
      type: 'PATCH',
      data: {
        'school_selections': selections
      }
    }).done(function(result) {
      if (result && !result['error']) {
        $this.removeClass('apply removing applied applying').addClass(classToAdd);
      }
    });

  });

});