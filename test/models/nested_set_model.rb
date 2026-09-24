# frozen_string_literal: true

# A minimal implementation of the API used by awesome_nested_set. It keeps the
# test focused on this plugin's integration without duplicating that gem here.
class NestedSetModel < Model
  scope :roots, -> { where(parent_id: nil) }

  def nested_set_scope
  end

  def left_column_name
    "position"
  end

  def self_and_siblings
    relation = parent_id ? self.class.where(parent_id: parent_id) : self.class.roots
    relation.order(:position).to_a
  end

  def move_left
    move_by(-1)
  end

  def move_right
    move_by(1)
  end

  private

  def move_by(offset)
    siblings = self_and_siblings
    sibling = siblings[siblings.index(self) + offset]
    return unless sibling

    old_position = position
    update_column(:position, sibling.position)
    sibling.update_column(:position, old_position)
  end
end
