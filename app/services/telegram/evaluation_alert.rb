module Telegram
  class EvaluationAlert
    def initialize(evaluation_request, client: Client.new)
      @evaluation_request = evaluation_request
      @client = client
    end

    def deliver
      return Rails.logger.info("Telegram alert skipped") unless client.configured?

      client.deliver(text)
      Rails.logger.info("Telegram alert sent for evaluation request #{evaluation_request.id}")
    end

    def text
      request = evaluation_request
      when_label = "#{I18n.l(request.preferred_on, format: :long)} · #{request.preferred_time_label}"

      [
        "Nueva solicitud de evaluación",
        "",
        "Nombre: #{request.name}",
        "Teléfono: #{request.phone}",
        "Correo: #{request.email}",
        "Objetivo: #{request.goal_label}",
        "Modalidad: #{request.modality_label}",
        "Cuándo: #{when_label}",
        "Nota: #{request.message}"
      ].join("\n")
    end

    private

    attr_reader :evaluation_request, :client
  end
end
