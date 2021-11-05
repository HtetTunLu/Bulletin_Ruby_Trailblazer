module Post::Operation

    class Export < Trailblazer::Operation
        step :download_post
        def download_post(options, params:, **)
            options["model"] = Post.all
        end
    end

    class Import < Trailblazer::Operation
        step :import_post
        def import_post(options, params:, **)
            user_id = params[:user_id]
            file = params[:file]
            updatable_attributes = ["title", "description", "status"]
            if !File.extname(file).eql?(".csv")
                options["error"] = "Please Choose a csv format"
            else
                CSV.foreach(file.path, headers: true) do |row|
                    if(row.count != 3)
                        options["error"] = "Post upload csv must have 3 columns"
                    else
                        if(row.headers[0] != "title" || row.headers[1] != "description" || row.headers[2] != "status")
                            options["error"] = "column names should be match with database columns"
                        end
                        @post = Post.new
                        @post.attributes = row.to_hash.slice(*updatable_attributes)
                        @post.create_user_id = user_id
                        @post.update_user_id = user_id
                        if !@post.valid?
                            errors = @post.errors
                            options["error1"] = @post.errors
                            options["error2"] = row[0]
                        else
                            @post.save
                        end
                    end             
                end
            end
        end
    end
end
