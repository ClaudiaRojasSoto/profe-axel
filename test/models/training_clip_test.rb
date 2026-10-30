require "test_helper"

class TrainingClipTest < ActiveSupport::TestCase
  test "publishes a clip with an image" do
    clip = build_clip

    assert clip.valid?
    assert_equal 1, clip.position
  end

  test "rejects a duration that is not minutes and seconds" do
    clip = build_clip(duration_label: "1:12")

    assert_not clip.valid?
  end

  test "requires an image" do
    clip = TrainingClip.new(clip_attributes)

    assert_not clip.valid?
    assert_includes clip.errors[:image], "es obligatoria"
  end

  test "lists published clips in position order" do
    later = build_clip(title: "Segundo", position: 2)
    later.save!
    first = build_clip(title: "Primero", position: 1)
    first.save!
    hidden = build_clip(title: "Oculto", position: 3, published: false)
    hidden.save!

    assert_equal [ "Primero", "Segundo" ], TrainingClip.published.ordered.pluck(:title)
  end

  private

  def build_clip(overrides = {})
    clip = TrainingClip.new(clip_attributes.merge(overrides))
    clip.image.attach(io: File.open(file_fixture("clip.png")), filename: "clip.png", content_type: "image/png")
    clip
  end

  def clip_attributes
    {
      title: "Fuerza con técnica",
      summary: "Control y progresión.",
      category: "fuerza",
      duration_label: "01:12",
      external_url: "https://www.instagram.com/profe_axel92/",
      image_alt: "Atleta con una barra"
    }
  end
end
