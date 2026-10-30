module Admin
  class EvaluationRequestsController < BaseController
    before_action :set_evaluation_request, only: :update

    def index
      @evaluation_requests = EvaluationRequest.recent
    end

    def update
      @evaluation_request.update!(contacted_at: Time.current)
      redirect_to admin_evaluation_requests_path, notice: "Solicitud marcada como contactada."
    end

    private

    def set_evaluation_request
      @evaluation_request = EvaluationRequest.find(params[:id])
    end
  end
end
