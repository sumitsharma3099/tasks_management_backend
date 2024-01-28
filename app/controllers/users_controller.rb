class UsersController < ApplicationController
    before_action :set_profile_pic_url, only: [:create]
    
    # This function is used to Create or Signup new User.
    def create
        params[:user][:profile_pic_url] = params[:user][:profile_pic_url].blank? ? "https://i.stack.imgur.com/l60Hf.png" : params[:user][:profile_pic_url]
        user = User.new(user_params)
        if user.save
            render_success({user: UserSerializer.new(user), jwt: issue_token(user)})
        else
            render_error(user.errors.full_messages.first)
        end
    end

    private

    def set_profile_pic_url
        if params[:user][:profile_pic_url].blank?
            params[:user][:profile_pic_url] = "https://i.stack.imgur.com/l60Hf.png"
        end
    end

    def user_params
        params.require(:user).permit(:full_name, :email, :password, :profile_pic_url)
    end
end
