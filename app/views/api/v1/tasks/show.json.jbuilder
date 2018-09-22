json.set! :task do
    json.extract! @task, :id, :name, :is_done, :due
end
