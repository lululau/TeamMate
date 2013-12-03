# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    category "MyString"
    subject "MyString"
    description "MyText"
    priority "MyString"
    assigned_to_user nil
    parent nil
    start_date "2013-12-03"
    due_date "2013-12-03"
    at_risk false
    reason_of_risk "MyString"
    project nil
  end
end
