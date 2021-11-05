require "reform/form/validation/unique_validator"
module Post::Contract
    class Create < Reform::Form

      property :title
      property :description
      property :status
      property :create_user_id
      property :update_user_id

      validates :title, unique: true, presence: true, length: { maximum: 255 }
      validates :description, presence: true
    end
end