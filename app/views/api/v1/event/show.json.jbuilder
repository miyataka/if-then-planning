json.set! :event do
    json.extract! @event, :id, :summary, :start, :end
end
