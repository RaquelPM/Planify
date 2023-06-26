require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    name = Faker::Name.name
    email = Faker::Internet.unique.email
    user_name = Faker::Internet.unique.user_name
    password = Faker::Internet.password(min_length: 8)

    User.new(name:, email:, user_name:, password:)
  end

  context 'validations' do
    it 'should validate presence of fields' do
      should validate_presence_of(:name)
      should validate_presence_of(:user_name)
      should validate_presence_of(:email)
    end

    it 'should validate uniqueness of fields' do
      should validate_uniqueness_of(:user_name).case_insensitive
      should validate_uniqueness_of(:email).case_insensitive
    end
    
    it 'should validate length of fields' do
      should validate_length_of(:name).is_at_least(3).is_at_most(80)
      should validate_length_of(:user_name).is_at_least(3).is_at_most(16)
      should validate_length_of(:password).is_at_least(8)
      should validate_length_of(:description).is_at_most(2000)
    end

    it 'should validate format of fields' do
      should allow_value('user_name-A123').for(:user_name)
      should allow_value('email@gmail.com').for(:email)
      should allow_value('(11) 12345-1234').for(:phone)
        
      should_not allow_value('297349284').for(:user_name)
      should_not allow_value('user name').for(:user_name)
      should_not allow_value('tanga@').for(:email)
      should_not allow_value('@gmail.com').for(:email)
      should_not allow_value('(11) 12345-123').for(:phone)
    end
  end

  context 'security' do
    it 'should have secure password' do
      should have_secure_password
    end
  end

  context 'associations' do
    it 'should have associations' do
      should have_many(:participations)
      should have_many(:events).through(:participations)
    end
  end

  context 'logic' do
    describe '#find_by_username' do
      before do
        subject.save
      end

      it 'should find user by username' do
        user = User.find_by_username(subject.user_name)

        expect(user).to_not be_nil
      end

      it 'should find user by username independing of case sensivity' do
        user = User.find_by_username(subject.user_name.upcase)

        expect(user).to_not be_nil
      end
    end

    describe '#search_by_username' do
      before do
        subject.user_name = 'user_name'

        subject.save
      end

      it 'should search users by similar username' do
        users = User.search_by_username('ser_na')

        expect(users.length).to_not eq(0)
      end
    end

    describe 'before_save' do
      it 'should save email with lowercase' do
        email = subject.email.clone

        subject.email.upcase!

        subject.save

        expect(email).to eq(subject.email)
      end
    end
  end
end