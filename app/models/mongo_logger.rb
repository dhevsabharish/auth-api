class MongoLogger
  include Mongoid::Document
  include Mongoid::Timestamps
  field :event, type: String
  field :user_id, type: Integer
  field :email, type: String
end
