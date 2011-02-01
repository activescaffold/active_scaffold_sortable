require 'active_scaffold_sortable'

begin
  ActiveScaffoldAssets.copy_to_public(ActiveScaffoldSortable.root)
rescue
  raise $! unless Rails.env == 'production'
end