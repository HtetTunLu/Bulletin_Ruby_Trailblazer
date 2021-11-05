module User::Operation
    class Reset < Trailblazer::Operation
        class Present < Trailblazer::Operation
            step :reset_pw
            def reset_pw(options, params:, **)
                options["model"] = User.find_by(email: params[:email])
                if (!User.exists?(email: params[:email]))
                    options["error"] = "Email doesn't exist"
                else
                    @token = options["model"].signed_id(purpose: "password_reset",expires_in: 15.minutes)
                    UserMailer.welcome_email(email: options["model"], token: @token).deliver_now
                    options["data"] = "Email sent with password reset instructions."
                    options["token"] = @token
                    options["email"] = options["model"].email
                end
            end
        end
        class Change < Trailblazer::Operation
            step :reseted_pw
            def reseted_pw(options, params:, **)
                options["model"] = User.find_by(email: params[:email])
                options["model"] = options["model"].update(password: params[:password])
                options["data"] = "Password has been reset"

                # @user = User.find_by(email: params[:email])
                # if @user.update(password: params[:password])
                #     render json: {data: "Password has been reset"}
                # else
                #     render json: {error: "this is error"}, status: 422
                # end
            end
        end
    step Nested(Present)
    end
end