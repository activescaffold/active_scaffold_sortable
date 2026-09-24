# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["DATABASE_URL"] ||= "sqlite3::memory:"

require "bundler/setup"
require "minitest/autorun"
require "rails"
require "action_controller/railtie"
require "active_record/railtie"
require "active_scaffold"
require "active_scaffold_sortable"

class TestApplication < Rails::Application
  config.root = File.expand_path("dummy", __dir__)
  config.eager_load = false
  config.logger = Logger.new(nil)
  config.secret_key_base = "active-scaffold-sortable-test-secret"
  config.hosts.clear
end

TestApplication.initialize!

Rails.application.routes.draw do
  concern :active_scaffold, ActiveScaffold::Routing::Basic.new(association: true)
  resources :sortable_models, concerns: :active_scaffold
  resources :auto_models, concerns: :active_scaffold
  resources :ancestry_models, concerns: :active_scaffold
  resources :nested_set_models, concerns: :active_scaffold
  resources :models, concerns: :active_scaffold
end

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.verbose = false
load File.expand_path("schema.rb", __dir__)

require_relative "models/model"
Dir[File.expand_path("models/*.rb", __dir__)].sort.each { |file| require file }
Dir[File.expand_path("controllers/*.rb", __dir__)].sort.each { |file| require file }

class ActionController::TestCase
  setup do
    @routes = Rails.application.routes
  end
end

class ActionDispatch::IntegrationTest
  setup do
    @routes = Rails.application.routes
  end
end
