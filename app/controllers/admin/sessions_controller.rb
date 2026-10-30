module Admin
  class SessionsController < ApplicationController
    include AdminAuthentication

    layout "admin_session"
    before_action :redirect_signed_in_admin, only: [ :new, :create ]

    def new
    end

    def create
      admin = AdminUser.find_by(email: session_email)
      if admin&.authenticate(params[:password])
        reset_session
        session[:admin_user_id] = admin.id
        redirect_to admin_root_path
      else
        flash.now[:alert] = "Correo o clave incorrectos."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      reset_session
      redirect_to new_admin_session_path, notice: "Sesión cerrada."
    end

    private

    def session_email
      params[:email].to_s.strip.downcase
    end

    def redirect_signed_in_admin
      redirect_to admin_root_path if current_admin
    end
  end
end
