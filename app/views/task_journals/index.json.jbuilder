json.array!(@task_journals) do |task_journal|
  json.extract! task_journal, :time_entry_hours, :old_done_ratio, :new_done_ratio, :task_id, :operator_id
  json.url task_journal_url(task_journal, format: :json)
end
