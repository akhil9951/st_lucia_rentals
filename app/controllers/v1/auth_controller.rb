module V1
    class AuthController < ApplicationController
      def login
        render json: { message: "Login works" }
      end
  
      def logout
        render json: { message: "Logout works" }
      end
    end
end