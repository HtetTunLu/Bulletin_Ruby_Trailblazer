module User::Operation
    class Password < Trailblazer::Operation
        class Present < Trailblazer::Operation
            step :pwupdate
            def pwupdate(options, params:, **)
                options["model"] = User.find(params[:id])
                if options["model"] && options["model"].authenticate(params[:current])
                else
                options["error"] = "Current Password Wrong!"
                end
            end
        end
        class Change < Trailblazer::Operation
            step :change_pw
            def change_pw(options, params:, **)
                options["model"] = User.find(params[:id])
                options["model"] = options["model"].update(password: params[:password])
            end
        end
    step Nested(Present)
    end
end