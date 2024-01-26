class ApplicationController < ActionController::API
    include ApiResponders

    def jwt_key
        Rails.application.credentials.jwt_key
    end

    # Function to genrate the token to login.
    def issue_token(user)
        JWT.encode({user_id: user.id}, jwt_key, "HS256")
    end

    # Function to decoded login token.
    def decoded_token
        begin
            JWT.decode(token, jwt_key, true, { :algorithm => 'HS256' })
        rescue => exception
            [{error: "Invalid Token"}]
        end    
    end
    
    def token
        request.headers["Authorization"]
    end

    def user_id
        decoded_token.first["user_id"]
    end

    def current_user
        @current_user ||= User.find_by(id: user_id)
    end

    def logged_in?
        !!current_user
    end

    # Function to auhtenticate user before some actions.
    def authenticate_user
        unless logged_in?
            render_error("User is not logged in/could not be found.")
        end
    end
end
