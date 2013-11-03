//= require_self

jQuery(document).ready(function($) {

  var $listing = $('.admin-listing').find('table');

  // Are we on a listing page?
  if ($listing.length) {

    var $allListingRows = $listing.find('tbody tr');

    // Filter functionality
    var $filter = $('[name="filter"]'),
        $filterCells = $listing.find('tbody td.js-filter-this'),
        $currentResults = $('.results .current');

    $filter.on('keyup', function(e) {
      var filterVal = $.trim($(this).val()).toLowerCase();
      if (filterVal.length) {
        // Filter table
        $allListingRows.hide();
        var $filteredRows = $filterCells.filter(function() {
          return $(this).text().toLowerCase().indexOf(filterVal) != -1;
        }).closest('tr');
        $filteredRows.show();
        $currentResults.text($filteredRows.length);
      } else {
        // Reset table
        $allListingRows.show();
        $currentResults.text($allListingRows.length);
      }
    });

    // Click row to edit functionality
    if ($listing.hasClass('editable')) {
      $(document).on('click', '.admin-listing tbody tr', function(e) {
        window.location = $(this).find('td.id').data('edit-path');
      });
    }

    // Delete a record functionality
    $(document).on('click', '.admin-listing tbody td.remove a', function(e) {
      e.stopPropagation();
      e.preventDefault();

      if (confirm('Are you sure you want to delete this record?')) {
        $.ajax({
          url: $(this).attr('href'),
          type: 'DELETE'
        }).done(function(result) {
          location.reload();
        });
      }
    });

  }

});