class CourseSerializer < ActiveModel::Serializer
  attributes %w[uuid name description difficulty]
end
