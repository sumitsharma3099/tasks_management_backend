class UsersController < ApplicationController

    # This function is used to Create or Signup new User.
    def create
        user = User.new(user_params)
        if user.save
            render_success({user: UserSerializer.new(user), jwt: issue_token(user)})
        else
            render_error(user.errors.full_messages.first)
        end
    end

    private

    def user_params
        params.require(:user).permit(:full_name, :email, :password)
    end
end
