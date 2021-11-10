require 'rails_helper'

RSpec.describe "Posts", type: :request do
    # List
    describe 'GET /post/list'do
        scenario 'Get all list' do
            # this will perform a GET request to the /post/list route
            get '/post/list'
            # we can also check the http status of the response
            expect(response.status).to eq(200)

            json = JSON.parse(response.body)
            # total post is 8
            expect(json.count).to eq(8)
        end
    end

    # List with user type
    describe 'POST /post/list/user' do
        scenario 'Get list with user type' do
            post '/post/list/user', params:{
                id: 8
            }
            # we can also check the http status of the response
            expect(response.status).to eq(200)
            json = JSON.parse(response.body)
            # total post is 1 with user id 8
            expect(json.count).to eq(1)
        end
    end

    # Confirm
    describe 'POST /post/confirm' do
        scenario 'valid post confirm' do
            post '/post/confirm', params:{
                title: 'testing request rspec',
                description: 'This is testing request',
                status: 1,
                create_user_id: 3,
                update_user_id: 3
            }
            # response should have HTTP Status 200
            expect(response.status).to eq(200)

            json = JSON.parse(response.body).deep_symbolize_keys

            # Check Validation Pass
            expect(json[:data]).to eq('pass')
        end
    end

    # Create
    describe 'POST /post/create' do
        scenario 'valid post create' do
            # send a POST request to /post/create, with these parameters
            # The controller will treat them as JSON 
            post '/post/create', params: {
                title: 'testing request rspec',
                description: 'This is testing request',
                status: 1,
                create_user_id: 3,
                update_user_id: 3
            }
        
            # response should have HTTP Status 201 Created
            expect(response.status).to eq(201)
        
            json = JSON.parse(response.body).deep_symbolize_keys
            
            # check the value of the returned response hash
            expect(json[:noti]).to eq('Post Successfully created')
          end
    end

    # Detail
    describe 'GET /post/detail' do
        scenario 'post detail' do
            get '/post/detail', params:{
                id: 27
            }
            json = JSON.parse(response.body).deep_symbolize_keys
            # Check get data from id no 27
            expect(json[:id]).to eq(27)
        end
    end

    # Edit Confirm
    describe 'PUT /post/edit' do
        scenario 'valid post edit confirm' do
            put '/post/edit', params:{
                id: 28,
                title: 'testing request rspec',
                description: 'This is testing request',
                status: 1,
                create_user_id: 3,
                update_user_id: 3
            }
            # response should have HTTP Status 204 
            expect(response.status).to eq(204)
        end

        scenario 'unvalid post edit confirm' do
            put '/post/edit', params:{
                id: 28,
                title: 'Ha Ha Ha',
                description: 'This is testing request',
                status: 1,
                create_user_id: 3,
                update_user_id: 3
            }
            # response should have HTTP Status 204 
            expect(response.status).to eq(422)
            json = JSON.parse(response.body).deep_symbolize_keys
            # unvalid cause of title already takenz
            expect(json[:title][0]).to eq("has already been taken")
        end
    end

    # Edit
    describe 'PUT /post/update' do
        scenario 'post update' do
            put '/post/update', params:{
                id: 28,
                title: 'testing request rspec',
                description: 'This is testing request',
                status: 1,
                create_user_id: 3,
                update_user_id: 3
            }

            #response should have HTTP Status 200
            expect(response.status).to eq(200)
        
            json = JSON.parse(response.body).deep_symbolize_keys
            
            # check the value of the returned response hash
            expect(json[:noti]).to eq('Post Successfully updated')
        end
    end

    # Soft Delete
    describe 'PUT /post/delete' do
        scenario 'Soft delete posts' do
            put '/post/delete', params: {
                id: 27,
                deleted_user_id: 3,
                deleted_at: '2021-11-02 00:00:00'
            }
            #response should have HTTP Status 200
            expect(response.status).to eq(200)

            json = JSON.parse(response.body).deep_symbolize_keys
            # Changed Delete User ID to 3 
            expect(json[:params][:deleted_user_id]).to eq("3")
        end
    end
end
