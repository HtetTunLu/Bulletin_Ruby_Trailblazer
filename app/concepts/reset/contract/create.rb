module Reset::Contract
    class Create < Reform::Form
      property :email
      property :token

      validates :email, presence: true
      validates :token, presence: true
    end
end