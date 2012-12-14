ActiveScaffold.sortable = function(element) {
  var form = element.up('form.as_form'), content, sortable_options = {};
  if (form) content = element.down('.sub-form');
  else content = element.down('.records');
  if (element.readAttribute('data-update')) {
    var csrf = {};
    csrf[$$('meta[name=csrf-param]')[0].readAttribute('content')] = $$('meta[name=csrf-token]')[0].readAttribute('content');
    var url = element.readAttribute('data-reorder-url').append_params(csrf);
    sortable_options.onUpdate = function() {
      var body = Sortable.serialize(content);
      var params = element.readAttribute('data-with');
      if (params) url += '&' + params;
      new Ajax.Request(url, {method: 'post', parameters: body});
    }
  }
  sortable_options.handle = element.readAttribute('data-handle');
  sortable_options.items = element.readAttribute('data-tag');
  Sortable.create(content, sortable_options);
};

document.observe('dom:loaded', function(){
  document.on('as:action_success', 'a.as_action', function(e, action_link) {
    var sortable = $(action_link.adapter).find('.sortable-container');
    if (sortable.length) sortable.invoke(function(s) { ActiveScaffold.sortable(s); });
  });
  var sortable = $$('.sortable-container');
  if (sortable.length) ActiveScaffold.sortable(sortable[0]);
});
