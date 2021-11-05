module Reset::Operation
    class Create < Trailblazer::Operation
        class Present < Trailblazer::Operation
            step Model(PasswordReset, :new)
            step Contract::Build( constant: Reset::Contract::Create )
            step Contract::Validate( )
            step Contract::Persist( )
            step :notify!
            def notify!(options, params:, **)
                options["result.notify"] = "hello"
            end   
        end
        class Update < Trailblazer::Operation
            step :update!
            def update!(options, params:, **)
                options["model"] = PasswordReset.find_by(token: params[:token])
            end
        end
        step Nested(Present)
    end
end

# @reset = PasswordReset.find_by(token: params[:token])
        # render json: @reset