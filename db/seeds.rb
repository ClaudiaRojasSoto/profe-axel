clips = [
  {
    title: "Fuerza con técnica",
    summary: "Control, postura y progresión antes de sumar más peso a la barra.",
    category: "fuerza",
    duration_label: "01:12",
    image_alt: "Atleta levantando una barra en un gimnasio oscuro",
    featured: true,
    position: 1,
    file: "fuerza.jpg"
  },
  {
    title: "Tu base importa",
    summary: "Un bloque simple para construir estabilidad y entrenar con más confianza.",
    category: "tecnica",
    duration_label: "00:48",
    image_alt: "Mancuernas preparadas para una sesión de fuerza",
    featured: false,
    position: 2,
    file: "tecnica.jpg"
  },
  {
    title: "Volver a moverte",
    summary: "No necesitas empezar perfecto: necesitas un plan que puedas repetir.",
    category: "habitos",
    duration_label: "00:56",
    image_alt: "Deportista entrenando en banco de gimnasio",
    featured: false,
    position: 3,
    file: "habitos.jpg"
  }
]

clips.each do |attrs|
  filename = attrs.delete(:file)
  clip = TrainingClip.find_or_initialize_by(title: attrs[:title])
  next if clip.persisted?

  clip.assign_attributes(attrs.merge(external_url: HomePage::INSTAGRAM_URL, published: true))
  File.open(Rails.root.join("db/seeds/images/#{filename}"), "rb") do |io|
    clip.image.attach(io: io, filename: filename, content_type: "image/jpeg")
    clip.save!
  end
end

if Rails.env.development?
  AdminUser.find_or_create_by!(email: "axel@profeaxel.cl") do |admin|
    admin.password = ENV.fetch("ADMIN_PASSWORD", "profe-axel-dev")
  end
elsif ENV["ADMIN_PASSWORD"].present?
  AdminUser.find_or_create_by!(email: ENV.fetch("ADMIN_EMAIL", "axel@profeaxel.cl")) do |admin|
    admin.password = ENV.fetch("ADMIN_PASSWORD")
  end
end
