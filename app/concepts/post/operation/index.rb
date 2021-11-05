module Post::Operation
    class Index < Trailblazer::Operation
      step :get_post_list
      def get_post_list(options, params:, **)
        options["model"] = []
        options["post"] = Post.where(deleted_user_id: [nil, ""])
        options["post"].each do |post|
            @create = post.create_user
            @update = post.update_user
            user_info = post.attributes
            user_info[:create_user] = @create.name
            user_info[:update_user] = @update.name
            user_info[:created_date] = post.created_at.strftime("%Y/%m/%d")
            user_info[:updated_date] = post.updated_at.strftime("%Y/%m/%d")
            options["model"] << user_info
        end
      end
    end

    class Index_User < Trailblazer::Operation
      step :post_with_user_type
      def post_with_user_type(options, params:, **)
        options["model"] = []
        options["posts"] = Post.where(deleted_at: [nil, ""])
        options["post"] = options[:posts].where(create_user_id: params[:id])
        options["post"].each do |post|
            @create = post.create_user
            @update = post.update_user
            user_info = post.attributes
            user_info[:create_user] = @create.name
            user_info[:update_user] = @update.name
            user_info[:created_date] = post.created_at.strftime("%Y/%m/%d")
            user_info[:updated_date] = post.updated_at.strftime("%Y/%m/%d")
            options["model"] << user_info
        end
      end
    end
  end