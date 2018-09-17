json.set! :task do
    json.extract! @task, :name, :is_done, :due
end
