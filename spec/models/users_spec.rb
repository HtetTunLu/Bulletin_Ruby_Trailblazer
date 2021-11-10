require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    User.new(name: "Rspec",
             email: "rspec@gmail.com",
             password: "rspec_password",
             profile: "screenshoot.png",
             role: 0, phone:"09955484077",
             address: "YGN", dob: "1990-10-03",
             create_user_id: 3,
             update_user_id:3)
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without password" do
    subject.password = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without profile" do
    subject.profile = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without type" do
    subject.role = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without created user" do
    subject.create_user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without updated user" do
    subject.update_user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid phone no too short" do
    subject.phone = "1"
    expect(subject).to_not be_valid
  end

  it "is not valid phone no too long" do
    subject.phone = "1" *14
    expect(subject).to_not be_valid
  end

  it "is not valid profile too long" do
    subject.profile = 'a' * 256
    expect(subject).to_not be_valid
  end

  it "is not valid role too long" do
    subject.role = 11
    expect(subject).to_not be_valid
  end

  it "is not valid address too long" do
    subject.address = 'a' * 256
    expect(subject).to_not be_valid
  end

  it "is not valid email already taken" do
    subject.email = "admin2@gmail.com"
    expect(subject).to_not be_valid
  end
end
