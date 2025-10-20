class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :dni, :email, :address
end
