class AutoModel < Model
  def acts_as_list_class
  end

  def position_column
    'position'
  end
end
