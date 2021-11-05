class ResetsController < ApplicationController
    before_action :authorized, only: [:auto_login]

    # TOKEN CREATE FOR RESET PASSWORD
    def create
        result = Reset::Operation::Create.(params: params)
        render json: result
    end

    # GET EMAIL FROM TOKEN
    def update
        result = Reset::Operation::Create::Update.(params: params)
        render json: result[:model]
    end
end
