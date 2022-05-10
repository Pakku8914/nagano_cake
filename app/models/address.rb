class Address < ApplicationRecord
  belongs_to :costomer

  # 住所を文字列結合
  def connect_address
    "〒#{postal_code} #{address}\n#{name}"
  end
end
