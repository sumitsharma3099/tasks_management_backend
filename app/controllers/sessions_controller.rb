class SessionsController < ApplicationController
    before_action :current_user, only: [:show]

    def create
        user = User.find_by_email(params[:email])
        if user && user.authenticate(params[:password])
            render_success({user: UserSerializer.new(user), jwt: issue_token(user)})
        else
            render_error("Please provide valid credentials.")
        end
    end

    def show
        if logged_in?
            render_success({user: UserSerializer.new(@current_user), jwt: issue_token(@current_user)})
        else
            render_error("User is not logged in/could not be found.")
        end
    end
end
