module Post::Operation
    class Update < Trailblazer::Operation
      class Present < Trailblazer::Operation
        step :model!
        step self::Contract::Build(constant: Post::Contract::Create)
        step self::Contract::Validate(key: :post)
        step :notify!
        def model!(options, params:, **)
          options["model"] = PostService.getPostById(params[:id])
          options["model"].title = params[:title]
          options["model"].description = params[:description]
        end
        def notify!(options, model:, **)
            options["result.notify"] = Rails.logger.info("New blog post #{model.title}.")
        end
      end
      class Detail < Trailblazer::Operation
        step :model!
        def model!(options, params:, **)
          options["model"] = PostService.getPostById(params[:id])
        end
      end
      class Delete < Trailblazer::Operation
        step :model!
        def model!(options, params:, **)
          options["model"] = PostService.getPostById(params[:id])
          options["model"] = options["model"].update(deleted_user_id: params[:deleted_user_id], deleted_at: params[:deleted_at])
        end
      end
      step Nested(Present)
      step self::Contract::Validate(key: :post)
      step self::Contract::Persist()
      step :notify!
    
      def notify!(options, model:, **)
        options["result.notify"] = Rails.logger.info("Update blog post #{model.title}.")
      end
    end
  end