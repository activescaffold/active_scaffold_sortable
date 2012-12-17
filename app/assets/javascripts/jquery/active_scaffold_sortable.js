ActiveScaffold.sortable = function(element) {
  var content, sortable_options = {};
  if (typeof(element) == 'string') {
    content = $('#' + element);
    element = content.closest('.sortable-container');
  } else {
    if (element.closest('form.as_form').length) content = element.find('.sub-form:first');
    else content = element.find('.records:first');
  }
  
  if (element.data('update')) {
    var csrf = {};
    var params = jQuery('meta[name=csrf-param]').attr('content') + '=' + jQuery('meta[name=csrf-token]').attr('content');
    var url = element.data('reorder-url');
    sortable_options.update = function(event, ui) {
      var body = jQuery(this).sortable('serialize',{key: encodeURIComponent(jQuery(this).attr('id') + '[]'), expression: new RegExp(element.data('format'))});
      var extra_params = element.data('with');
      if (extra_params) body += '&' + extra_params;
      jQuery.post(url, body + '&' + params);
    }
  }
  sortable_options.handle = element.data('handle');
  sortable_options.items = element.data('tag');
  content.sortable(sortable_options);
};

jQuery(document).ready(function($) {
  $(document).on('as:action_success', 'a.as_action', function(e, action_link) {
    var sortable = $('.sortable-container', action_link.adapter);
    if (sortable.length) $.each(sortable, function(i, s) { ActiveScaffold.sortable(s); });
  });
  var sortable = $('.sortable-container');
  if (sortable.length) ActiveScaffold.sortable(sortable);
});
