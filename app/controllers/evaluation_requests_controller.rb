class EvaluationRequestsController < ApplicationController
  def create
    return redirect_to(agenda_path, notice: success_notice, status: :see_other) if honeypot?

    evaluation_request = EvaluationRequest.new(evaluation_request_params)
    if evaluation_request.save
      NotifyEvaluationRequestJob.perform_later(evaluation_request.id)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "agenda_form",
            partial: "home/success",
            locals: { message: success_notice }
          )
        end
        format.html { redirect_to agenda_path, notice: success_notice, status: :see_other }
      end
    else
      @page = HomePage.new(evaluation_request: evaluation_request)
      render_failure
    end
  end

  private

  def agenda_path
    root_path(anchor: "agenda")
  end

  def honeypot?
    params[:website].present?
  end

  def success_notice
    "Listo. Axel te va a contactar para conocer tu objetivo y confirmar el horario."
  end

  def render_failure
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "agenda_form",
          partial: "home/form",
          locals: { page: @page }
        ), status: :unprocessable_entity
      end
      format.html { render "home/show", status: :unprocessable_entity }
    end
  end

  def evaluation_request_params
    params.require(:evaluation_request).permit(
      :name, :phone, :email, :goal, :modality, :preferred_on, :preferred_time, :message, :consent
    )
  end
end
