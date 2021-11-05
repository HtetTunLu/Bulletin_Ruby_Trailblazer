class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]

    # USER LIST FOR ADMIN TYPE
    def list 
      result = User::Operation::List.(params: params)
      render json: result[:model]
    end

    # USER LIST FOR USER TYPE
    def list_user
      result  = User::Operation::List_User.(params: params)
      render json: result[:model]
    end

    # USER REGISTER CONFIRM
    def confirm
      result = User::Operation::Create::Confirm.(params: params)
      if result["result.notify"]
        return render json: {data: 'pass'}
      else
        render json: result["contract.default"].errors[:email], status: 422
      end
    end

    # USER REGISTER
    def create
      result = User::Operation::Create.(params:params)
      User::Operation::Create::Image.(params:params)
      render json: {noti: "Post Successfully created"}
    end

    # USER'S IMAGE AND ROLE INFO
    def get
      result = User::Operation::Get.(params: params)
      render json: result
    end

    # USER'S INFO
    def details
      result = User::Operation::Detail.(params: params)
      render json: result
    end
    
    # USER EDIT
    def update
      @user = User.find_by(id: params[:id])
      @user.email = params[:email]
      if !@user.valid?
        render json: @user.errors, status: 422
      else
        User::Operation::Update::Image.(params: params)
        User::Operation::Update.(params: params)
        render json: {data: "Profile Updated Successfully"}      
      end
    end

    # USER'S PASSWORD CHANGE ERROR
    def pwupdate
      result = User::Operation::Password.(params: params)
      if result[:error]
        render json: result[:error], status: 401
      end
    end
    
    # USER'S PASSWORD CHANGE SUCCESS
    def pwupdated
      result = User::Operation::Password::Change.(params: params)
      token = encode_token({user_id: result[:params][:id]})
      render json: {user: result[:params], token: token, noti: "Password is successfully updated"}
    end

    # USER SOFT DELETE
    def delete
      result = User::Operation::Update::Delete.(params: params)
      render json: {data: "User successfully deleted"}
    end

    # Email SEND FOR USER RESET PASSWORD
    def reset
      result = User::Operation::Reset.(params: params)
      if result["error"]
        render json: result["error"], status: 422
      else
        render json: result
      end
    end

    # USER RESET PASSWORD
    def reset_pw
      result = User::Operation::Reset::Change.(params: params)
      render json: result
    end

    # LOGGING IN
    def login
      result = User::Operation::Login.(params: params)
      if result["error"]
        render json: result["error"], status: 401
      elsif
        token = encode_token({user_id: result["model"].id})
        render json: {user: result["model"], token: token}
      end
    end

  end