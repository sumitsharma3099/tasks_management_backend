class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :sort_title, :sort_description
end
