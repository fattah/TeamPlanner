class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    callback_information = request.env["omniauth.auth"]
    if callback_information.info.email.end_with?('nascenia.com') || callback_information.info.email.end_with?('bdipo.com')
      @user = User.from_omniauth(callback_information)
      if @user.present?
        sign_in_and_redirect @user
        set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    else
      flash[:error] = 'Only Nascenia Emplyee are allowed to use this application'
      render 'devise/sessions/new'
    end
  end
end