json.set! :events do
    json.array! @response.items do |item|
        json.extract! item, :atenddees, :display_name, :created, :creator, :discription, :end, :etag, :html_link,
            :i_cal_uid, :id, :kind, :organizer, :private_copy, :reminders, :sequence, :start, :status, :summary, :updated
    end
end
