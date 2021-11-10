require 'rails_helper'

RSpec.describe Post, :type => :model do
  subject {
    Post.new(title: "This is Rspec Testing",
             description: "Lorem ipsum",
             status: 1,
             create_user_id: 3,
             update_user_id: 3)
            }
  
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    
    it "is not valid without a title" do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a description" do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it "is not valid title too long" do
      subject.title= 'a' * 256
      expect(subject).to_not be_valid
    end

    it "is not valid without status" do
      subject.status = nil
      expect(subject).to_not be_valid
    end

    it "is not valid status too long" do
      subject.status = 11
      expect(subject).to_not be_valid
    end

    it "is not valid without create user" do
      subject.create_user_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without update user" do
      subject.update_user_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid title already taken" do
      subject.title = "Ha Ha Ha"
      expect(subject).to_not be_valid
    end
end 
