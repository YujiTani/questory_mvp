class QuestSerializer < ActiveModel::Serializer
  attribute :uuid, key: :id
  attribute :name
  attribute :description
  attribute :state
end
