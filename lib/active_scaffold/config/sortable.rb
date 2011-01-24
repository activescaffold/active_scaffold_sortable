module ActiveScaffold::Config
  class Sortable < Base
    def initialize(core_config)
      @options = {}
      @core = core_config
      
      self.column = core_config.model.new.position_column unless (@core.model.instance_methods & [:acts_as_list_class, 'acts_as_list_class']).empty?
      self.column = core_config.model.new.left_column_name unless (@core.model.instance_methods & [:nested_set_scope, 'nested_set_scope']).empty?
      if self.column.nil?
        raise "ActiveScaffoldSortable: Missing sortable attribute '#{core_config.model.new.position_column}' in model '#{core_config.model.to_s}'" if @core.model.instance_methods.include? 'acts_as_list_class'
        raise "ActiveScaffoldSortable: Missing sortable attribute '#{core_config.model.new.left_column_name}' in model '#{core_config.model.to_s}'" if @core.model.instance_methods.include? 'nested_set_scope'
      end

    end

    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(%{(^.*)/lib/active_scaffold/config/sortable.rb})[1]

    self.crud_type = :update
    
    attr_reader :column
    def column=(column_name)
      @column = @core.columns[column_name]
      Rails.logger.error("ActiveScaffold Sortable: postion column: #{column_name} not found in model") if @column.nil?
      @column
    end
    
    attr_accessor :options
  end
end
