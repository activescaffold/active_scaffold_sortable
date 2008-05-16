module ActiveScaffold::Config
  class Sortable < Base
    def initialize(core_config)
      
    end
    
    attr_writer :column
    
    def column
      @column ||= "position"
    end
    
  end
end