FactoryBot.define do
    factory :user do
        name {'testing request rspec'}
        email {'rspec@gmail.com'}
        password {'rspec_password'}
        profile {'Screenshot.png'}
        role {1}
        phone{'09955484077'}
        address {'YGN'}
        dob {'2021-10-03'}
        create_user_id {3}
        update_user_id {3}
    end
end