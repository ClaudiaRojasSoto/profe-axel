require "test_helper"

class EvaluationRequestsTest < ActionDispatch::IntegrationTest
  test "stores a request and confirms it on the agenda" do
    assert_enqueued_with(job: NotifyEvaluationRequestJob) do
      assert_difference -> { EvaluationRequest.count }, 1 do
        post evaluation_requests_path, params: { evaluation_request: valid_params }
      end
    end

    assert_redirected_to root_path(anchor: "agenda")
    follow_redirect!
    assert_select "h3", text: "Quedó registrada"
  end

  test "confirms the request in place when turbo submits the form" do
    assert_difference -> { EvaluationRequest.count }, 1 do
      post evaluation_requests_path, params: { evaluation_request: valid_params }, as: :turbo_stream
    end

    assert_response :success
    assert_match "Quedó registrada", response.body
  end

  test "keeps the form when the request cannot be saved" do
    assert_no_enqueued_jobs only: NotifyEvaluationRequestJob do
      assert_no_difference -> { EvaluationRequest.count } do
        post evaluation_requests_path, params: { evaluation_request: valid_params.merge(message: "") }
      end
    end

    assert_response :unprocessable_entity
    assert_select "h3", text: "Cuéntame sobre ti"
    assert_match "no puede estar en blanco", response.body
  end

  test "ignores a filled honeypot" do
    assert_no_enqueued_jobs only: NotifyEvaluationRequestJob do
      assert_no_difference -> { EvaluationRequest.count } do
        post evaluation_requests_path, params: { evaluation_request: valid_params, website: "https://spam.test" }
      end
    end

    assert_redirected_to root_path(anchor: "agenda")
  end

  test "replaces the form for turbo when the request is invalid" do
    post evaluation_requests_path, params: { evaluation_request: valid_params.merge(name: "") }, as: :turbo_stream

    assert_response :unprocessable_entity
    assert_match "agenda_form", response.body
  end

  private

  def valid_params
    {
      name: "Camila Soto",
      phone: "+56912345678",
      email: "camila@example.com",
      goal: "fuerza",
      modality: "online",
      preferred_on: Date.current + 2,
      preferred_time: "noche",
      message: "Entreno hace un año.",
      consent: "1"
    }
  end
end
