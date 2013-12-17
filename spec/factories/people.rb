# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    name "MyString"
    email "MyString"
    password "MyString"
    role "MyString"
    avatar 1
    locked false
  end
end
