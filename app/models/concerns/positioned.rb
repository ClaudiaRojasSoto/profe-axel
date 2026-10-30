module Positioned
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order(:position, :id) }

    validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

    before_validation :assign_next_position, on: :create
  end

  private

  def assign_next_position
    self.position = nil if position.blank?
    self.position ||= (self.class.maximum(:position) || 0) + 1
  end
end
