class UsersController < ApplicationController
    before_action :authenticate_user, only: [:update]
    before_action :set_profile_pic_url, only: [:create, :update]
    
    # This function is used to Create or Signup new User.
    def create
        user = User.new(user_params)
        if user.save
            render_success({user: UserSerializer.new(user), jwt: issue_token(user)})
        else
            render_error(user.errors.full_messages.first)
        end
    end

    def update
        if @current_user.present?
            if @current_user.update_columns(full_name: params[:user][:full_name], profile_pic_url: params[:user][:profile_pic_url])
                render_success({user: UserSerializer.new(@current_user), jwt: issue_token(@current_user)})
            else
                render_error(@current_user.errors.full_messages.first)
            end
        else
            render_error('User Not Found.')
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

    def user_update_params
        params.require(:user).permit(:full_name, :profile_pic_url)
    end
end
