require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "shows the training offer and published work" do
    create_clip(title: "Fuerza con técnica")
    create_clip(title: "Borrador", published: false)

    get root_path

    assert_response :success
    assert_select "h1", text: /Más fuerte/
    assert_select "a", text: /Agendar/i
    assert_select "h3", text: /Fuerza con técnica/
    assert_select "h3", text: "Borrador", count: 0
  end

  private

  def create_clip(title:, published: true)
    clip = TrainingClip.new(
      title: title,
      summary: "Control, postura y progresión.",
      category: "fuerza",
      duration_label: "01:12",
      external_url: HomePage::INSTAGRAM_URL,
      image_alt: "Atleta entrenando",
      published: published
    )
    clip.image.attach(io: File.open(file_fixture("clip.png")), filename: "clip.png", content_type: "image/png")
    clip.save!
  end
end
