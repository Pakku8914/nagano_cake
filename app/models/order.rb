class Order < ApplicationRecord
    belongs_to :costomer
    has_many :order_details
    enum payment_method: {credit_card: 0, transfer: 1}
    enum status: {pay_wait: 0, conf_pay: 1, making: 2, sending_prepare: 3, sent: 4}
end
