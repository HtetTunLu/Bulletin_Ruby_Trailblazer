class User::Operation::Create < Trailblazer::Operation
    class Confirm < Trailblazer::Operation
      step Model(User, :new)
      step Contract::Build( constant: User::Contract::Base )
      step Contract::Validate( )
      step :notify!
      def notify!(options, model:, **)
        options["result.notify"] = Rails.logger.info("New blog post #{model.name}.")
      end
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
    step Nested( Confirm )
    step Contract::Persist( )
end