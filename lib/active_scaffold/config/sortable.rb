module ActiveScaffold::Config
  class Sortable < Base
    def initialize(core_config)
      @core = core_config
      @options = self.class.options.clone
      
      self.column = core_config.model.new.position_column unless (@core.model.instance_methods & [:acts_as_list_class, 'acts_as_list_class']).empty?
      self.column = core_config.model.new.left_column_name unless (@core.model.instance_methods & [:nested_set_scope, 'nested_set_scope']).empty?
      if self.column.nil?
        raise "ActiveScaffoldSortable: Missing sortable attribute '#{core_config.model.new.position_column}' in model '#{core_config.model.to_s}'" if @core.model.instance_methods.include? 'acts_as_list_class'
        raise "ActiveScaffoldSortable: Missing sortable attribute '#{core_config.model.new.left_column_name}' in model '#{core_config.model.to_s}'" if @core.model.instance_methods.include? 'nested_set_scope'
      end
      self.add_handle_column = self.class.add_handle_column
      self.refresh_list = self.class.refresh_list
    end

    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(%{(^.*)/lib/active_scaffold/config/sortable.rb})[1]

    cattr_accessor :add_handle_column
    @@add_handle_column = false

    cattr_accessor :options
    @@options = {}

    cattr_accessor :refresh_list

    self.crud_type = :update
    
    attr_reader :column
    def column=(column_name)
      @column = @core.columns[column_name]
      if @column.nil?
        Rails.logger.error("ActiveScaffold Sortable: postion column: #{column_name} not found in model")
      else
        @column.form_ui = :hidden
        @column.css_class = 'sortable-handle'
        @column.label = ''
        @column.weight = -2**(0.size * 8 -2)
      end
      @column
    end
    
    attr_accessor :options
    attr_accessor :refresh_list
    
    attr_reader :add_handle_column
    def add_handle_column=(where)
      if where
        raise(ArgumentError, "Unknown handle column position: #{where}") unless [:first, :last].include?(where)
        @options[:handle] = 'td.sortable-handle'
        define_handle_column
        @column.weight = 2**(0.size * 8 -2) -1 unless where == :first
        if @core.actions.include? :list
          if where == :first
            @core.list.columns = [:active_scaffold_sortable] + @core.list.columns.to_a unless @core.list.columns.include? :active_scaffold_sortable
          else
            @core.list.columns.add :active_scaffold_sortable 
          end
        end
      else
        @options.delete(:handle)
      end
      @add_handle_column = where
    end
    
    protected
    
    def define_handle_column
      @core.columns.add :active_scaffold_sortable
      @core.columns.exclude :active_scaffold_sortable
      @core.columns[:active_scaffold_sortable].label = ''
      @core.columns[:active_scaffold_sortable].sort = false
    end
  end
end
