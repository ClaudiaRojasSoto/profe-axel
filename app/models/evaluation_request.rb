class EvaluationRequest < ApplicationRecord
  GOALS = {
    "fuerza" => "Ganar fuerza",
    "perder-grasa" => "Bajar grasa",
    "movilidad" => "Mejorar movilidad",
    "volver-entrenar" => "Volver a entrenar",
    "otro" => "Otro objetivo"
  }.freeze

  MODALITIES = {
    "presencial" => "Presencial",
    "online" => "Online",
    "por-definir" => "Por definir"
  }.freeze

  PREFERRED_TIMES = {
    "manana" => "Mañana",
    "mediodia" => "Mediodía",
    "tarde" => "Tarde",
    "noche" => "Noche"
  }.freeze

  scope :recent, -> { order(created_at: :desc) }

  normalizes :name, with: ->(name) { name.strip }
  normalizes :phone, with: ->(phone) { phone.to_s.strip.presence }
  normalizes :email, with: ->(email) { email.to_s.strip.downcase.presence }
  normalizes :message, with: ->(message) { message.to_s.strip.presence }

  validates :name, presence: true, length: { maximum: 80 }
  validates :phone, length: { maximum: 30 }, allow_nil: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :goal, inclusion: { in: GOALS.keys }
  validates :modality, inclusion: { in: MODALITIES.keys }
  validates :preferred_time, inclusion: { in: PREFERRED_TIMES.keys }
  validates :preferred_on, presence: true
  validates :message, length: { maximum: 2000 }, allow_nil: true
  validates :consent, acceptance: true
  validate :contact_channel_present
  validate :preferred_on_is_available

  def goal_label
    GOALS[goal]
  end

  def modality_label
    MODALITIES[modality]
  end

  def preferred_time_label
    PREFERRED_TIMES[preferred_time]
  end

  def contacted?
    contacted_at.present?
  end

  def self.options_for(collection)
    collection.map { |value, label| [ label, value ] }
  end

  private

  def contact_channel_present
    return if phone.present? || email.present?

    errors.add(:base, :contact_channel_missing)
  end

  def preferred_on_is_available
    return if preferred_on.blank? || preferred_on >= Date.current

    errors.add(:preferred_on, :in_the_past)
  end
end
