require "test_helper"

class Telegram::EvaluationAlertTest < ActiveSupport::TestCase
  test "names the person and how to reach them" do
    client = RecordingClient.new
    request = EvaluationRequest.new(request_attributes)

    Telegram::EvaluationAlert.new(request, client: client).deliver

    message = client.messages.sole
    assert_includes message, "Nueva solicitud de evaluación"
    assert_includes message, "Nombre: Camila Soto"
    assert_includes message, "Teléfono: +56912345678"
    assert_includes message, "Correo: camila@example.com"
    assert_includes message, "Objetivo: Ganar fuerza"
    assert_includes message, "Modalidad: Online"
    assert_includes message, "Nota: Entreno hace un año."
  end

  test "skips delivery when Telegram is not configured" do
    client = RecordingClient.new(configured: false)
    request = EvaluationRequest.new(request_attributes)

    Telegram::EvaluationAlert.new(request, client: client).deliver

    assert_empty client.messages
  end

  class RecordingClient
    attr_reader :messages

    def initialize(configured: true)
      @configured = configured
      @messages = []
    end

    def configured?
      @configured
    end

    def deliver(text)
      messages << text
    end
  end

  private

  def request_attributes
    {
      name: "Camila Soto",
      phone: "+56912345678",
      email: "camila@example.com",
      goal: "fuerza",
      modality: "online",
      preferred_on: Date.new(2026, 11, 2),
      preferred_time: "noche",
      message: "Entreno hace un año.",
      consent: true
    }
  end
end
