module User::Operation
    class Get < Trailblazer::Operation
        step :get_data
        def get_data(options, params:, **)
            @user = User.find(params[:id])
            @role = @user[:role]
            photoname = @user.profile
            path = "app/assets/images/"+photoname
            data = File.open(path, 'rb') {|file| file.read }
            photofile = "data:image;base64,#{Base64.encode64(data)}"
            options["image"] = photofile
            options["role"] = @role
        end
    end
    class Detail < Trailblazer::Operation
        step :detail_data
        def detail_data(options, params:, **)
            @user = User.find(params[:id])
            photoname = @user.profile
            path = "app/assets/images/"+photoname
            data = File.open(path, 'rb') {|file| file.read }
            photofile = "data:image;base64,#{Base64.encode64(data)}"
            options["image"] = photofile
            options["user"] = @user
        end
    end
end
