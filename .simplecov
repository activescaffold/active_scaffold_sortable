# frozen_string_literal: true

require 'simplecov_json_formatter'

SimpleCov.configure do
  add_filter '/test/'
  track_files '{app,lib}/**/*.rb'
end

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
]
