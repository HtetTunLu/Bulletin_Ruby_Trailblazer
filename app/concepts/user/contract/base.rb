require "reform/form/validation/unique_validator"
module User::Contract
    class Base < Reform::Form
      property :name
      property :email
      property :password
      property :profile
      property :role
      property :phone
      property :address
      property :dob
      property :create_user_id
      property :update_user_id
      property :deleted_user_id
      property :deleted_at
  
      validates :email, presence: true, unique: true, length: { maximum: 100 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  
    end
    class Base_update < Reform::Form
      property :name
      property :email
      property :password_digest
      property :profile
      property :role
      property :phone
      property :address
      property :dob
      property :create_user_id
      property :update_user_id
      property :deleted_user_id
      property :deleted_at
  
      validates :email, presence: true, length: { maximum: 100 }, format: { with: URI::MailTo::EMAIL_REGEXP }, unique: true
  
    end
  end