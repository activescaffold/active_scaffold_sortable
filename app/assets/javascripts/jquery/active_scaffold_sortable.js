ActiveScaffold.update_positions = function(content) {
  if (typeof(content) == 'string') content = jQuery('#' + content);
  var element = content.closest('.sortable-container');
  jQuery.each(content.find('.sub-form-record input[name$="[' + element.data('column') + ']"]'), function(i, field) {
    jQuery(field).val(i+1); // don't use 0
  });
}
ActiveScaffold.sortable = function(element) {
  var form, content, sortable_options = {};
  if (typeof(element) == 'string') {
    content = jQuery('#' + element);
    element = content.closest('.sortable-container');
    form = element.closest('form.as_form').length > 0;
  } else {
    element = jQuery(element);
    form = element.closest('form.as_form').length > 0;
    if (form) content = element;
    else content = element.find('.records:first');
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
        var body = jQuery(this).sortable('serialize',{key: encodeURIComponent(jQuery(this).attr('id') + '[]'), expression: new RegExp(element.data('format'))});
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
