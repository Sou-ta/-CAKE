class Item < ApplicationRecord
  has_many :cart_items
  has_many :customers,through: :cart_items

  has_many :order_details
  has_many :orders,through: :order_details

  belongs_to :genre
  has_one_attached :image

  validates :name,presence:true
  validates :introduction,presence:true
  validates :price,presence:true

  def full_price
   (price*1.1).floor
  end
end
