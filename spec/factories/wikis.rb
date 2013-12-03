# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wiki, :class => 'Wikis' do
    subject "MyString"
    content "MyText"
    parent nil
    project nil
    author nil
  end
end
