require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    # List
    describe 'Get user data from list controller' do
        
        scenario 'Get all list' do
            # this will perform get data from users#list controller
            get :list
            # we can also check the http status of the response
            expect(response.status).to eq(200)

            json = JSON.parse(response.body)
            # total user is 19 and 7 are deleted = 12
            expect(json.count).to eq(12)
        end
    end

    # List with user type
    describe 'Get user data from list_user controller' do
        scenario 'Get list with user type' do
            post :list_user, params:{
                id: 8
            }
            # we can also check the http status of the response
            expect(response.status).to eq(200)
            json = JSON.parse(response.body)
            # total user is 1 with user id 8
            expect(json.count).to eq(1)
        end
    end

    # Confirm
    describe 'Confirm User' do
        scenario 'valid user confirm' do
            user1 = build(:user)
            post :confirm, params: {
                name: user1.name,
                email: user1.email,
                password: user1.password,
                profile: user1.profile,
                role: user1.role,
                phone: user1.phone,
                address: user1.address,
                dob: user1.dob,
                create_user_id: user1.create_user_id,
                update_user_id: user1.update_user_id
            }
            # response should have HTTP Status 200
            expect(response.status).to eq(200)

            json = JSON.parse(response.body).deep_symbolize_keys

            # Check Validation Pass
            expect(json[:data]).to eq('pass')
        end
        scenario 'unvalid user confirm with unique email' do
            user1 = build(:user, email: "scm.htettunlu@gmail.com")
            post :confirm, params: {
                name: user1.name,
                email: user1.email,
                password: user1.password,
                profile: user1.profile,
                role: user1.role,
                phone: user1.phone,
                address: user1.address,
                dob: user1.dob,
                create_user_id: user1.create_user_id,
                update_user_id: user1.update_user_id
            }
            # response should have HTTP Status 422
            expect(response.status).to eq(422)

            json = JSON.parse(response.body)

            # Check Validation Pass
            expect(json[0]).to eq('has already been taken')
        end
    end

    # Create
    describe 'Create User' do
        scenario 'valid user create' do
            # The controller will treat them as JSON 
            user1 = build(:user)
            post :create, params: {
                name: user1.name,
                email: user1.email,
                password: user1.password,
                profile: user1.profile,
                role: user1.role,
                phone: user1.phone,
                address: user1.address,
                dob: user1.dob,
                create_user_id: user1.create_user_id,
                update_user_id: user1.update_user_id
            }
        
            # response should have HTTP Status 200
            expect(response.status).to eq(200)
        
            json = JSON.parse(response.body).deep_symbolize_keys
            
            # check the value of the returned response hash
            expect(json[:noti]).to eq('Post Successfully created')
          end
    end

    # Edit
    describe 'Edit User' do
        scenario 'Valid Edit User' do
            user1 = build(:user, id: 8)
            put :update, params: {
                id: user1.id,
                name: user1.name,
                email: user1.email,
                password: user1.password,
                profile: user1.profile,
                role: user1.role,
                phone: user1.phone,
                address: user1.address,
                dob: user1.dob,
                create_user_id: user1.create_user_id,
                update_user_id: user1.update_user_id
            }
            expect(response.status).to eq(200)
            json = JSON.parse(response.body).deep_symbolize_keys
            
            # check the value of the returned response hash
            expect(json[:data]).to eq('Profile Updated Successfully')
        end
        scenario 'unValid Edit User' do
            user1 = build(:user, id: 8, email: "scm.htettunlu@gmail.com")
            put :update, params: {
                id: user1.id,
                name: user1.name,
                email: user1.email,
                password: user1.password,
                profile: user1.profile,
                role: user1.role,
                phone: user1.phone,
                address: user1.address,
                dob: user1.dob,
                create_user_id: user1.create_user_id,
                update_user_id: user1.update_user_id
            }
            expect(response.status).to eq(422)
            json = JSON.parse(response.body).deep_symbolize_keys
            # check the value of the returned response hash
            expect(json[:email][0]).to eq('has already been taken')
        end
    end

    # Change Password
    describe 'Change Password' do
        scenario 'unvalid Change password' do
            user1 = build(:user, id: 3, password: '11111111')
            put :pwupdate, params:{
                id: user1.id,
                current: user1.password
            }
            # Unauthorized
            expect(response.status).to eq(401)

            json = response.body
            expect(json).to eq("Current Password Wrong!")
        end

        scenario 'Changed password' do
            user1 = build(:user, id: 3, password: '11111111')
            put :pwupdated, params:{
                id: user1.id,
                password: user1.password
            }
            # Changed
            expect(response.status).to eq(200)
            json = JSON.parse(response.body).deep_symbolize_keys
            # check the value of the returned response hash
            expect(json[:noti]).to eq('Password is successfully updated')
        end
    end

    # Soft Delete
    describe 'User Soft Delete' do
        scenario 'soft delete user' do
            user1 = build(:user, id: 8, deleted_user_id: 3, deleted_at: '2021-10-03')
            put :delete, params: {
                id: user1.id,
                deleted_user_id: user1.deleted_user_id,
                deleted_at: user1.deleted_at
            }
            # deleted
            expect(response.status).to eq(200)
            json = JSON.parse(response.body).deep_symbolize_keys
            # check the value of the returned response hash
            expect(json[:data]).to eq('User successfully deleted')
        end
    end

    # Login
    describe "User Login" do
        scenario 'unvalid login' do
            user1 = build(:user, email: "unknown@gmail.com", password: "unknown_password")
            post :login, params: {
                email: user1.email,
                password: user1.password
            }
            # Unauthorized
            expect(response.status).to eq(401)

            json = response.body
            expect(json).to eq("Invalid email or password")
        end
        scenario 'valid login' do
            user1 = build(:user, email: "testing5@gmail.com", password: "htettunlu385")
            post :login, params: {
                email: user1.email,
                password: user1.password
            }
            # Logged In
            expect(response.status).to eq(200)

            json = JSON.parse(response.body).deep_symbolize_keys
            expect(json[:user][:email]).to eq("testing5@gmail.com")
        end
    end

    # Reset Password
    describe 'Reset Password' do
        scenario 'unvalid reset password' do
            user1 = build(:user, email: "unknown@gmail.com")
            post :reset, params: {
                email: user1.email
            }
            # Email doesn't exist
            expect(response.status).to eq(422)

            json = response.body
            expect(json).to eq("Email doesn't exist")
        end
        scenario 'valid reset password' do
            user1 = build(:user, email: "testing5@gmail.com")
            post :reset, params: {
                email: user1.email
            }
            # Email exist and mail send
            expect(response.status).to eq(200)

            json = JSON.parse(response.body).deep_symbolize_keys
            expect(json[:data]).to eq("Email sent with password reset instructions.")
        end
        scenario 'reseted password' do
            user1 = build(:user, email: "testing5@gmail.com", password: "11111111")
            put :reset_pw, params: {
                email: user1.email,
                password: user1.password
            }
            # Password Reseted
            expect(response.status).to eq(200)

            json = JSON.parse(response.body).deep_symbolize_keys
            expect(json[:data]).to eq("Password has been reset")
        end
    end
end
