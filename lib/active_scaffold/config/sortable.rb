module ActiveScaffold::Config
  class Sortable < Base
    def initialize(core_config)
      @options = {}
      @core = core_config
      @column = core_config.columns[core_config.model.new.position_column]
    end

    self.crud_type = :update
    
    attr_reader :column
    
    attr_accessor :options
  end
end
