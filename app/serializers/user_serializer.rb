class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :profile_pic_url
end
