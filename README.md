# Drag-and-drop sorting for Active Scaffold

`active_scaffold_sortable` adds AJAX drag-and-drop ordering to Active Scaffold
lists and association subforms.

It supports:

- ordinary ordered lists, including automatic setup for `acts_as_list` models;
- sortable `has_many` association subforms;
- sibling ordering in nested-set trees using the `awesome_nested_set` API;
- sibling ordering in [Ancestry](https://github.com/stefankroes/ancestry)
  trees;
- a dedicated drag-handle column, optional list refreshes, and custom DOM
  selectors for non-standard list markup.

## Requirements

- Ruby 2.0 or newer
- Active Scaffold 4.0.0.rc1 or newer
- a Rails version supported by the selected Active Scaffold version
- jQuery UI Sortable on pages that use this plugin

For Rails 3 applications, use an `active_scaffold_sortable` 3.2.x release.

## Installation

Add the gem to the application's `Gemfile`:

```ruby
gem "active_scaffold_sortable"
```

Then run:

```console
bundle install
```

The engine registers the Active Scaffold action, route, JavaScript,
stylesheet, and view overrides automatically.

## Ordered lists

### With `acts_as_list`

Add a position column and configure the model with
[`acts_as_list`](https://github.com/brendon/acts_as_list):

```ruby
# db/migrate/..._add_position_to_entries.rb
add_column :entries, :position, :integer
add_index :entries, :position
```

```ruby
class Entry < ApplicationRecord
  acts_as_list
end
```

The plugin detects `acts_as_list`, enables the `:sortable` action, and uses
the model's configured position column. No Active Scaffold controller
configuration is needed.

Scopes configured in `acts_as_list` still define the logical lists. A rendered
Active Scaffold list should contain records from only one scope so that a drag
does not mix independent lists.

### Without `acts_as_list`

Sorting can use any persisted column that accepts one-based integer positions.
Enable the action and select the column explicitly:

```ruby
class EntriesController < ApplicationController
  active_scaffold :entry do |config|
    config.actions << :sortable
    config.sortable.column = :position
  end
end
```

On every drop, the visible records receive consecutive values beginning at
`1`. Updates are made directly with `update_all`, so validations and model
callbacks do not run. If the table has an `updated_at` column, it is updated.
The reorder action uses Active Scaffold's update authorization check.

## Sortable association subforms

A collection association is draggable in a create or update form when the
associated model's Active Scaffold configuration includes `:sortable`. This
works whether sorting was enabled automatically by `acts_as_list` or manually:

```ruby
class TasksController < ApplicationController
  active_scaffold :task do |config|
    config.actions << :sortable
    config.sortable.column = :position
  end
end
```

For example, a `Project` form that renders a `has_many :tasks` subform will
allow its task rows to be reordered. Dragging updates the hidden position
fields in the form; the order is persisted when the parent form is submitted,
not through a separate reorder request. New associated records without a
position are placed after the highest existing position.

The association must be a collection. Singular associations are not sortable.
The associated scaffold may exclude the `:list` action when sorting is needed
only in a subform.

## Tree models

Tree support reorders nodes only among their current siblings. It does not move
a node to a different parent.

### Nested sets (`awesome_nested_set`)

Models using
[`awesome_nested_set`](https://github.com/collectiveidea/awesome_nested_set)
are detected automatically:

```ruby
class Category < ApplicationRecord
  acts_as_nested_set
end
```

The plugin enables `:sortable`, uses the model's configured left column, and
calls the nested-set movement methods to preserve valid left and right bounds.
Root nodes can be reordered as siblings as well.

Detection is API-based rather than gem-name-based. A different nested-set
implementation may work only if it provides the same API used here:
`nested_set_scope`, `left_column_name`, `self_and_siblings`, `move_left`, and
`move_right`. `awesome_nested_set` is the intended integration; no other
nested-set gem is explicitly supported by this project.

### Ancestry

Ancestry models are recognized during reordering, but they are **not** enabled
automatically. Add a separate position column and configure sorting manually:

```ruby
class Category < ApplicationRecord
  has_ancestry
end
```

```ruby
class CategoriesController < ApplicationController
  active_scaffold :category do |config|
    config.actions << :sortable
    config.sortable.column = :position
  end
end
```

The submitted records are reordered within the first record's sibling set.
Both root nodes and children are supported. The `ancestry` column itself is a
path, not a sibling position, and should not be configured as the sortable
column.

## Configuration

### Drag handle

By default, the whole row is the drag handle. Add a dedicated handle column at
the beginning or end of the list with:

```ruby
config.sortable.add_handle_column = :first
# or
config.sortable.add_handle_column = :last
```

Only `:first`, `:last`, and `false`/`nil` are accepted.

### Refresh after reordering

The default response only reapplies alternating row styles. Refresh the entire
Active Scaffold list after each reorder when other displayed values depend on
the order:

```ruby
config.sortable.refresh_list = true
```

### Advanced DOM options

`config.sortable.options` is merged into the sortable container's `data-*`
attributes. Supported overrides include:

```ruby
config.sortable.options = {
  tag: "> tr",                    # selector for draggable items
  handle: ".my-drag-handle",      # selector that starts dragging
  content_selector: ".my-records", # sortable content within the container
  key: "as_entries-tbody",        # serialized request parameter base
  format: "^[^_-].*-(.*)-row$",   # extracts the record ID from a row ID
  with: "scope_id=42"             # extra reorder request parameters
}
```

These are integration hooks for custom Active Scaffold markup. They are not a
general pass-through for every jQuery UI Sortable option. When overriding
`key`, keep it aligned with the parameter name expected by the reorder action.

The same settings can be used as defaults for every sortable scaffold. Set
them in an initializer before Active Scaffold configurations are built:

```ruby
ActiveScaffold::Config::Sortable.add_handle_column = :first
ActiveScaffold::Config::Sortable.refresh_list = true
ActiveScaffold::Config::Sortable.options = { handle: ".my-drag-handle" }
```

## Effects on the Active Scaffold list

Enabling `:sortable` also:

- disables pagination so all draggable records are present in one list;
- orders the list ascending by the sortable column;
- disables sorting by other columns;
- hides the sortable column from normal action columns, while retaining it as
  a hidden field in subforms.

Because the browser submits only rendered rows, filters and nested views update
only the matching subset. Non-rendered records retain their stored positions,
which can produce duplicate positions in an ordinary list. Keep each sortable
view within one logical list or sibling set, and use filtering with care.

## Support

For help, use the
[Active Scaffold discussion group](https://groups.google.com/group/activescaffold)
or [open an issue](https://github.com/activescaffold/active_scaffold_sortable/issues).

## Contributing

Fork the [repository](https://github.com/activescaffold/active_scaffold_sortable),
make the change with tests, and open a pull request.

## License

Released under the [MIT License](LICENSE.txt).

## Authors

- Tim Harper
- Sergio Cambra
- Volker Hochstein
