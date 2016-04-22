class ResponseRelation < ActiveRecord::Base
  belongs_to :post, class_name: "Micropost"
  belongs_to :act, class_name: "User"
  belongs_to :rec, class_name: "User"
end
