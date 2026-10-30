class NotifyEvaluationRequestJob < ApplicationJob
  retry_on ::Telegram::DeliveryError, wait: :polynomially_longer, attempts: 5

  def perform(evaluation_request_id)
    evaluation_request = EvaluationRequest.find_by(id: evaluation_request_id)
    return if evaluation_request.blank?

    ::Telegram::EvaluationAlert.new(evaluation_request).deliver
  end
end
