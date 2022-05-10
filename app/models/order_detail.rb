class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item
  enum making_status: {impossible: 0, wait: 1, making: 2, made: 3}
end
