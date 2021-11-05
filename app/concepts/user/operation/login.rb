module User::Operation
    class Login < Trailblazer::Operation
        step :login!
        def login!(options, params:, **)
            options["model"] = User.find_by(email: params[:email])
            if options["model"] && options["model"].authenticate(params[:password])
            else
                options["error"] = "Invalid email or password"
            end
        end
    end
end
