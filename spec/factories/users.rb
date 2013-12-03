# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
    password "MyString"
    role "MyString"
    remember_me_token "MyString"
    avatar 1
    locked false
    last_signin_time "2013-12-03 02:37:19"
  end
end
