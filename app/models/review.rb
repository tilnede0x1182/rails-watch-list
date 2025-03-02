class Review < ApplicationRecord
  belongs_to :list

  validates :content, presence: true, length: { minimum: 5 }
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
