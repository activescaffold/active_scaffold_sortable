module ActiveScaffold::Config
  class Sortable < Base
    def initialize(core_config)
      
    end
    
    attr_reader :column
    
    def column
      @column ||= "position"
    end
    
  end
end