# encoding: utf-8
ENV["RAILS_ENV"] = "test"

require 'test/unit'
# You can use "rake test AR_VERSION=2.0.5" to test against 2.0.5, for example.
# The default is to use the latest installed ActiveRecord.
if ENV["AR_VERSION"]
  gem 'activerecord', "#{ENV["AR_VERSION"]}"
  gem 'actionpack', "#{ENV["AR_VERSION"]}"
  gem 'activesupport', "#{ENV["AR_VERSION"]}"
end
require 'rubygems'
require 'active_record'
require 'action_controller'
require 'action_view/test_case'
require 'action_mailer'
require 'active_support'
require 'initializer'
ActionController::Base::logger = ActiveSupport::BufferedLogger.new(Tempfile.new('log').path)

RAILS_ROOT = File.join(File.dirname(__FILE__), '../../../..')
Rails.configuration = Rails::Configuration.new

require 'shoulda'
require 'shoulda/rails'
require 'mocha'
begin
  require 'redgreen'
rescue LoadError
end

ActiveSupport::Dependencies.load_paths = %w(test/models test/controllers lib ../active_scaffold/lib).map {|dir| File.dirname(__FILE__) + "/../#{dir}"}
$:.unshift *ActiveSupport::Dependencies.load_paths

require File.join(File.dirname(__FILE__), '../../active_scaffold/environment')
require 'sortable'

ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'
  map.resources :sortable_models, :active_scaffold => true
  map.resources :auto_models, :active_scaffold => true
  map.resources :models, :active_scaffold => true
end

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"
silence_stream(STDOUT) do
  load(File.dirname(__FILE__) + "/schema.rb")
end
