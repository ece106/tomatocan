class EventSerializer < ActiveModel::Serializer
  attributes :name, :start_at, :end_at, :desc, :topic, :user_id
end