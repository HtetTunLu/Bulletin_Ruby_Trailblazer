module User::Operation
    class Update < Trailblazer::Operation
      class Present < Trailblazer::Operation
        step Model(User, :find_by)
        step Contract::Build(constant: User::Contract::Base_update)
        step Contract::Validate()
        step Contract::Persist()
      end
      class Image < Trailblazer::Operation
        step :add_image!
        def add_image!(options, params:, **)
            if params[:filename]
                name = params[:filename].original_filename
                path = File.join("app", "assets" , "images", name)
                File.open(path, "wb") { |f| f.write(params[:filename].read) }
            end
        end
      end
      class Delete < Trailblazer::Operation
        step :model!
        def model!(options, params:, **)
          options["model"] = User.find(params[:id])
          options["model"] = options["model"].update(deleted_user_id: params[:deleted_user_id], deleted_at: params[:deleted_at])
        end
      end
      step Nested(Present)
      step :notify!
    
      def notify!(options, model:, **)
        options["result.notify"] = "hello"
      end
    end
  end