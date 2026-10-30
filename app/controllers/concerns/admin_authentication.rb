module AdminAuthentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_admin
  end

  private

  def current_admin
    return if session[:admin_user_id].blank?

    @current_admin ||= AdminUser.find_by(id: session[:admin_user_id])
  end

  def require_admin
    return if current_admin

    redirect_to new_admin_session_path, alert: "Inicia sesión para administrar el contenido."
  end
end
