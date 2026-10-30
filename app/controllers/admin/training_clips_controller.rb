module Admin
  class TrainingClipsController < BaseController
    before_action :set_training_clip, only: [ :edit, :update, :destroy ]

    def index
      @training_clips = TrainingClip.with_attached_image.ordered
    end

    def new
      @training_clip = TrainingClip.new(external_url: HomePage::INSTAGRAM_URL)
    end

    def create
      @training_clip = TrainingClip.new(training_clip_params)
      if @training_clip.save
        redirect_to admin_training_clips_path, notice: "Entrenamiento publicado."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @training_clip.update(training_clip_params)
        redirect_to admin_training_clips_path, notice: "Entrenamiento actualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @training_clip.destroy
      redirect_to admin_training_clips_path, notice: "Entrenamiento eliminado."
    end

    private

    def set_training_clip
      @training_clip = TrainingClip.find(params[:id])
    end

    def training_clip_params
      params.require(:training_clip).permit(
        :title, :summary, :category, :duration_label, :external_url,
        :image_alt, :position, :featured, :published, :image
      )
    end
  end
end
