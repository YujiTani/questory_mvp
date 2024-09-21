class QuestSerializer < ActiveModel::Serializer
  attributes %w[uuid name description state]
end
