require "test_helper"

class EvaluationRequestTest < ActiveSupport::TestCase
  test "accepts a request with phone and a future date" do
    request = EvaluationRequest.new(valid_attributes)

    assert request.valid?
  end

  test "accepts email when the phone is missing" do
    request = EvaluationRequest.new(valid_attributes.merge(phone: nil, email: "camila@example.com"))

    assert request.valid?
  end

  test "requires a way to get in touch" do
    request = EvaluationRequest.new(valid_attributes.merge(phone: nil, email: nil))

    assert_not request.valid?
    assert_includes request.errors[:base], "Deja un teléfono o un correo para que Axel pueda contactarte."
  end

  test "rejects a past preferred date" do
    request = EvaluationRequest.new(valid_attributes.merge(preferred_on: Date.current - 1))

    assert_not request.valid?
    assert_includes request.errors[:preferred_on], "tiene que ser hoy o una fecha futura"
  end

  test "requires consent" do
    request = EvaluationRequest.new(valid_attributes.merge(consent: false))

    assert_not request.valid?
  end

  private

  def valid_attributes
    {
      name: "Camila Soto",
      phone: "+56912345678",
      goal: "fuerza",
      modality: "presencial",
      preferred_on: Date.current + 3,
      preferred_time: "tarde",
      message: "Quiero volver a entrenar.",
      consent: true
    }
  end
end
