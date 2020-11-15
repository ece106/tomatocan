class UserSerializer < ActiveModel::Serializer

  attributes :name, :permalink, :profilepic, :about, :genre1, :genre2, :genre3, :bannerpic, :resume

end