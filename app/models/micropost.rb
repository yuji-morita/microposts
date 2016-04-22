class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  
  has_many :guships,  -> { where(score: 1) },
                           class_name: "ResponseRelation",
                           foreign_key: "post_id",
                           dependent:   :destroy
  has_many :gu_users,
                      through: :guships, source: :act
  has_many :buships,  -> { where(score: -1) },
                           class_name: "ResponseRelation",
                           foreign_key: "post_id",
                           dependent:   :destroy
  has_many :bu_users,
                      through: :buships, source: :act             
  end