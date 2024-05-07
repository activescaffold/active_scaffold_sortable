module ActiveScaffold
  module Actions
    ActiveScaffold.autoload_subdir('actions', self, ActiveScaffoldSortable.root + '/lib')
  end

  module Config
    ActiveScaffold.autoload_subdir('config', self, ActiveScaffoldSortable.root + '/lib')
  end

  module Helpers
    ActiveScaffold.autoload_subdir('helpers', self, ActiveScaffoldSortable.root + '/lib')
  end
end
