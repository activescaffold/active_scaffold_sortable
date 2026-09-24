# frozen_string_literal: true

ActiveRecord::Schema.define(version: 1) do
  create_table :models, force: true do |t|
    t.string :name
    t.integer :position
    t.integer :parent_id
    t.timestamps
  end
  add_index :models, :position
  add_index :models, :parent_id
end
