ActiveScaffold.update_positions = function(content) {
  if (typeof(content) == 'string') content = jQuery('#' + content);
  var element = content.closest('.sortable-container');
  jQuery.each(content.find('.sub-form-record input[name$="[' + element.data('column') + ']"]'), function(i, field) {
    jQuery(field).val(i+1); // don't use 0
  });
}
ActiveScaffold.sortable = function(element) {
  var fixHelper = function(e, ui) {
    ui.find('*').each(function() {
      var $this = jQuery(this);
      $this.data('sortable-prev-style', $this.attr('style'));
      $this.width($this.width());
    });
    return ui;
  };
  var copyHelperToPlaceholder = function(e, ui) {
    var items = ui.placeholder.find('td');
    ui.helper.find('td').each(function(i) {
      jQuery(items[i]).width(jQuery(this).width());
    });
  };
  var restoreHelper = function(e, ui) {
    ui.helper.find('*').each(function() {
      var style = jQuery(this).data('sortable-prev-style');
      if (style) jQuery(this).attr('style', style);
      else jQuery(this).removeAttr('style');
      jQuery(this).removeData('sortable-prev-style');
    });
  };
  var form, content, sortable_options = {containment: 'parent', tolerance: 'pointer', forcePlaceholderSize: true, placeholder: 'sortable-highlight', helper: fixHelper, beforeStop: restoreHelper, start: copyHelperToPlaceholder};
  if (typeof(element) == 'string') {
    content = jQuery('#' + element);
    element = content.closest('.sortable-container');
    form = element.closest('form.as_form').length > 0;
  } else {
    element = jQuery(element);
    form = element.closest('form.as_form').length > 0;
    if (form) content = element;
    else content = element.find(element.data('contentSelector') || '.records:first');
  }
  
  if (form) {
    sortable_options.update = function(event, ui) {
      ActiveScaffold.update_positions(content);
    };
  } else {
    var url = element.data('reorder-url');
    if (url) {
      var csrf = jQuery('meta[name=csrf-param]').attr('content') + '=' + jQuery('meta[name=csrf-token]').attr('content');
      sortable_options.update = function(event, ui) {
        var $this = jQuery(this),
          body = $this.sortable('serialize',{key: encodeURIComponent(($this.data('key') || $this.attr('id')) + '[]'), expression: new RegExp(element.data('format'))});
        var params = element.data('with');
        if (params) body += '&' + params;
        jQuery.post(url, body + '&' + csrf);
      };
    }
  }
  sortable_options.handle = element.data('handle');
  sortable_options.items = element.data('tag');
  content.sortable(sortable_options);
};

jQuery(document).ready(function($) {
  $(document).on('as:action_success', 'a.as_action', function(e, action_link) {
    var sortable = $('.sortable-container', action_link.adapter);
    if (sortable.length) $.each(sortable, function(i, s) { ActiveScaffold.sortable($(s)); });
  });
  $(document).on('as:element_updated', function(e) {
    var sortable = $('.sortable-container', e.target);
    if (sortable.length) $.each(sortable, function(i, s) { ActiveScaffold.sortable($(s)); });
  });
  var sortable = $('.sortable-container');
  if (sortable.length) ActiveScaffold.sortable(sortable);
});
