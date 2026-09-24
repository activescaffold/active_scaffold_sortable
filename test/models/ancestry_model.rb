# frozen_string_literal: true

class AncestryModel < Model
  belongs_to :parent, class_name: "AncestryModel", optional: true
  has_many :children, class_name: "AncestryModel", foreign_key: :parent_id

  scope :roots, -> { where(parent_id: nil) }

  def self.ancestry_column
    :ancestry
  end

  def is_root?
    parent_id.nil?
  end
end
