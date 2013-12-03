# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_journal do
    time_entry_hours 1
    old_done_ratio 1
    new_done_ratio 1
    task nil
    operator nil
  end
end
