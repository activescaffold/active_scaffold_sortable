# encoding: utf-8

ActiveRecord::Schema.define(:version => 1) do
  create_table 'models', :force => true do |t|
    t.string 'name'
    t.integer 'position'
  end
  add_index 'models', ['position']
end
