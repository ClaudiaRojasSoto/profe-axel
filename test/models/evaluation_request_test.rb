require "test_helper"

class EvaluationRequestTest < ActiveSupport::TestCase
  test "accepts a request with phone and a future date" do
    request = EvaluationRequest.new(valid_attributes)

    assert request.valid?
  end

  test "requires phone, email, and message" do
    %i[phone email message].each do |attribute|
      request = EvaluationRequest.new(valid_attributes.merge(attribute => nil))

      assert_not request.valid?, "#{attribute} should be required"
      assert_includes request.errors[attribute], "no puede estar en blanco"
    end
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
      email: "camila@example.com",
      goal: "fuerza",
      modality: "presencial",
      preferred_on: Date.current + 3,
      preferred_time: "tarde",
      message: "Quiero volver a entrenar.",
      consent: true
    }
  end
end
