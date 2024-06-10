class MongoLogger
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :event, type: String
  field :user_id, type: Integer
  field :email, type: String
end