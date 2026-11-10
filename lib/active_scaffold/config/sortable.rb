# frozen_string_literal: true

module ActiveScaffold::Config
  class Sortable < Base
    def initialize(core_config)
      super
      @options = self.class.options.clone

      model = core_config.model
      self.column = model.new.position_column if model.method_defined?(:acts_as_list_class)
      self.column = model.new.left_column_name if model.method_defined?(:nested_set_scope)
      if column.nil? && model.method_defined?(:acts_as_list_class)
        missing_column = model.new.position_column
        raise "ActiveScaffoldSortable: Missing sortable attribute '#{missing_column}' in model '#{model}'"
      end
      if column.nil? && model.method_defined?(:nested_set_scope)
        missing_column = model.new.left_column_name
        raise "ActiveScaffoldSortable: Missing sortable attribute '#{missing_column}' in model '#{model}'"
      end
      self.add_handle_column = self.class.add_handle_column
      self.refresh_list = self.class.refresh_list
    end

    cattr_accessor :plugin_directory,
                   instance_accessor: false,
                   default: File.expand_path(__FILE__).match(%r{(^.*)/lib/active_scaffold/config/sortable.rb})[1]

    cattr_accessor :add_handle_column, instance_accessor: false, default: false

    cattr_accessor :options, instance_accessor: false, default: {}

    cattr_accessor :refresh_list, instance_accessor: false, default: nil

    self.crud_type = :update

    attr_reader :column, :add_handle_column

    def column=(column_name)
      @column = @core.columns[column_name]
      if @column.nil?
        Rails.logger.error("ActiveScaffold Sortable: postion column: #{column_name} not found in model")
      else
        @column.form_ui = :hidden
        @column.css_class = 'sortable-handle'
        @column.label = ''
        @column.weight = -(2**((0.size * 8) - 2))
      end
    end

    attr_accessor :options, :refresh_list

    def add_handle_column=(where)
      if where
        raise(ArgumentError, "Unknown handle column position: #{where}") unless %i[first last].include?(where)

        @options[:handle] = 'td.sortable-handle'
        define_handle_column
        @column.weight = (2**((0.size * 8) - 2)) - 1 unless where == :first
        add_handle_to_list(where) if @core.actions.include? :list
      else
        @options.delete(:handle)
      end
      @add_handle_column = where
    end

    protected

    def add_handle_to_list(where)
      if where == :first
        unless @core.list.columns.include? :active_scaffold_sortable
          @core.list.columns = [:active_scaffold_sortable] + @core.list.columns.to_a
        end
      else
        @core.list.columns.add :active_scaffold_sortable
      end
    end

    def define_handle_column
      @core.columns.add :active_scaffold_sortable
      @core.columns.exclude :active_scaffold_sortable
      @core.columns[:active_scaffold_sortable].label = ''
      @core.columns[:active_scaffold_sortable].sort = false
    end

    UserSettings.class_eval do
      user_attr :options, :refresh_list
    end
  end
end
