class Post::Operation::Create < Trailblazer::Operation
  class Confirm < Trailblazer::Operation
    step Model(Post, :new)
    step Contract::Build( constant: Post::Contract::Create )
    step self::Contract::Validate()
    step :notify!
    def notify!(options, model:, **)
      options["result.notify"] = Rails.logger.info("New blog post #{model.title}.")
    end
  end

  step Nested( Confirm )
  step Contract::Validate( key: :post )
  step Contract::Persist( )
  step :notify!

  def notify!(options, model:, **)
    options["result.notify"] = Rails.logger.info("New blog post #{model.title}.")
  end
end