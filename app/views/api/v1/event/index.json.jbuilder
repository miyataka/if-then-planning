json.set! :events do
    json.array! @events do |event|
        json.extract! event, :id, :summary, :start, :end, :description, :kind, :reminders, :status
    end
end
