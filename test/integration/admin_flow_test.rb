require "test_helper"

class AdminFlowTest < ActionDispatch::IntegrationTest
  setup do
    @admin = AdminUser.create!(email: "axel@profeaxel.cl", password: "profe-axel-dev")
  end

  test "asks for a session before showing content" do
    get admin_root_path

    assert_redirected_to new_admin_session_path
  end

  test "rejects a wrong password" do
    post admin_session_path, params: { email: @admin.email, password: "incorrecta" }

    assert_response :unprocessable_entity
    assert_match "incorrectos", response.body
  end

  test "publishes a clip and marks a request as contacted" do
    post admin_session_path, params: { email: @admin.email, password: "profe-axel-dev" }
    assert_redirected_to admin_root_path

    post admin_training_clips_path, params: {
      training_clip: {
        title: "Base fuerte",
        summary: "Un bloque para empezar.",
        category: "tecnica",
        duration_label: "00:48",
        external_url: "https://www.instagram.com/profe_axel92/",
        image_alt: "Mancuernas en el piso",
        published: "1",
        image: fixture_file_upload("clip.png", "image/png")
      }
    }
    assert_redirected_to admin_training_clips_path
    follow_redirect!
    assert_match "Base fuerte", response.body

    request = EvaluationRequest.create!(
      name: "Camila Soto",
      phone: "+56912345678",
      goal: "fuerza",
      modality: "presencial",
      preferred_on: Date.current + 1,
      preferred_time: "manana",
      consent: true
    )

    patch admin_evaluation_request_path(request)
    assert_redirected_to admin_evaluation_requests_path
    assert request.reload.contacted?
  end

  private

  def fixture_file_upload(name, type)
    Rack::Test::UploadedFile.new(file_fixture(name), type)
  end
end
