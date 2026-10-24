class User < ApplicationRecord
  devise :rememberable

  has_many :works, dependent: :destroy
end
