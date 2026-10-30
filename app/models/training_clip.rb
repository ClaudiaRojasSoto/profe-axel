class TrainingClip < ApplicationRecord
  include Positioned

  CATEGORIES = {
    "fuerza" => "Fuerza",
    "tecnica" => "Técnica",
    "habitos" => "Hábitos"
  }.freeze

  IMAGE_TYPES = %w[image/jpeg image/png image/webp].freeze
  DURATION_FORMAT = /\A\d{2}:\d{2}\z/

  has_one_attached :image

  scope :published, -> { where(published: true) }

  validates :title, :summary, :image_alt, :external_url, presence: true
  validates :title, length: { maximum: 80 }
  validates :summary, length: { maximum: 280 }
  validates :category, inclusion: { in: CATEGORIES.keys }
  validates :duration_label, format: { with: DURATION_FORMAT }
  validates :external_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validate :acceptable_image

  def category_label
    CATEGORIES[category]
  end

  def self.category_options
    CATEGORIES.map { |value, label| [ label, value ] }
  end

  private

  def acceptable_image
    unless image.attached?
      errors.add(:image, :blank)
      return
    end

    return if IMAGE_TYPES.include?(image.blob.content_type)

    errors.add(:image, :invalid)
  end
end
