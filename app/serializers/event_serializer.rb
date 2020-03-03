class EventSerializer < ActiveModel::Serializer
    attributes :id, :name, :usrid, :start_at
end