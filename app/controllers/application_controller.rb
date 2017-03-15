class ApplicationController < ActionController::Base
 # protect_from_forgery with: :exception
 #we have to do this because otherwise we get a token authentication issue. This is how to do on cross platform posting
  protect_from_forgery with: :null_session
  include SessionsHelper

private
     # Before filters


     # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def evaluate_auth_and_redirect(user_id)
      if current_user.id != user_id.user_id
        flash[:notice] = 'You do not have access to this part of the site' 
        redirect_to(root_url)
      end
    end
end
