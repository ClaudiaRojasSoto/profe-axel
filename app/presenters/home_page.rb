class HomePage
  INSTAGRAM_URL = "https://www.instagram.com/profe_axel92/"
  Step = Struct.new(:number, :title, :summary, :icon, keyword_init: true)

  def initialize(evaluation_request: EvaluationRequest.new)
    @evaluation_request = evaluation_request
  end

  attr_reader :evaluation_request

  def instagram_url
    INSTAGRAM_URL
  end

  def training_clips
    @training_clips ||= TrainingClip.published.with_attached_image.ordered.to_a
  end

  def featured_clip
    training_clips.find(&:featured?) || training_clips.first
  end

  def supporting_clips
    return [] if featured_clip.nil?

    training_clips.excluding(featured_clip)
  end

  def method_steps
    [
      step("01", "Entrenamiento 1 a 1", "Sesiones enfocadas en tu nivel, tus tiempos y una progresión que puedas sostener.", :user),
      step("02", "Plan personalizado", "Una ruta clara para ganar fuerza, mejorar composición corporal o volver a moverte.", :target),
      step("03", "Seguimiento real", "Ajustes, correcciones y acompañamiento para que cada semana tenga un propósito.", :pulse)
    ]
  end

  def benefits
    [ "Evaluación inicial", "Técnica y progresión", "Plan adaptable", "Acompañamiento cercano" ]
  end

  def process_steps
    [
      step("01", "Conversemos", "Cuéntame tu meta y tu experiencia actual."),
      step("02", "Evaluamos", "Definimos tu punto de partida y el plan correcto."),
      step("03", "Avanzamos", "Entrenamos, medimos y ajustamos juntos.")
    ]
  end

  def follow_up_steps
    [
      step("01", "Envías tu solicitud"),
      step("02", "Axel conversa contigo"),
      step("03", "Definen tu primera sesión")
    ]
  end

  private

  def step(number, title, summary = nil, icon = nil)
    Step.new(number: number, title: title, summary: summary, icon: icon)
  end
end
