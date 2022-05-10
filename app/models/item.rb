class Item < ApplicationRecord
  belongs_to :genre
  has_many :cart_items
  has_one_attached :image
  has_many :order_details

  # def get_image(width, height)
  #   unless image.attached?
  #     file_path = Rails.root.join("app/assets/images/noimage.jpg")
  #     image.attach(io:File.open(file_path), filename: "no-image.jpg", content_type: "image/jpeg")
  #   end
  #   image.variant(resize_to_limit: [width, height])
  # end

  def self.search(keyword)
    where(["name like?", "%#{keyword}%"])
  end
end
