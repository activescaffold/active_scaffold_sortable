# frozen_string_literal: true

module ActiveScaffold
  module Actions
    ActiveScaffold.autoload_subdir('actions', self, File.expand_path('..', __dir__))
  end

  module Config
    ActiveScaffold.autoload_subdir('config', self, File.expand_path('..', __dir__))
  end

  module Helpers
    ActiveScaffold.autoload_subdir('helpers', self, File.expand_path('..', __dir__))
  end
end
