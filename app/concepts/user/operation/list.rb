module User::Operation
    class List < Trailblazer::Operation
      step :model!
      def model!(options, params:, **)
        options["model"] = []
        options["user"] = User.where(deleted_user_id: [nil, ""])
        options["user"].each do |user|
            @create = User.find_by(id: user.create_user_id)
            @update = User.find_by(id: user.update_user_id)
            user_info = user.attributes
            user_info[:user_name] = @create.name
            user_info[:update_name] = @update.name
            user_info[:created_at] = user.created_at.strftime("%Y-%m-%d")
            user_info[:updated_at] = user.updated_at.strftime("%Y-%m-%d")
            options["model"] << user_info
        end
      end
    end
    class List_User < Trailblazer::Operation
        step :user_with_user_type
        def user_with_user_type(options, params:, **)
          options["model"] = []
          options["users"] = User.where(deleted_at: [nil, ""])
          options["user"] = options[:users].where(create_user_id: params[:id])
          options["user"].each do |user|
              @create = User.find_by(id: user.create_user_id)
              @update = User.find_by(id: user.update_user_id)
              user_info = user.attributes
              user_info[:user_name] = @create.name
              user_info[:update_name] = @update.name
              user_info[:created_at] = user.created_at.strftime("%Y/%m/%d")
              user_info[:updated_at] = user.updated_at.strftime("%Y/%m/%d")
              options["model"] << user_info
          end
        end
      end
  end