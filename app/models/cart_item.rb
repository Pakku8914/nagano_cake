class CartItem < ApplicationRecord
  belongs_to :costomer
  belongs_to :item
end
