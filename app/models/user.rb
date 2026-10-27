class User < ApplicationRecord
  devise :rememberable

  has_many :works, dependent: :destroy
  has_many :production_units, through: :works
  has_many :process_checks, through: :production_units
end
