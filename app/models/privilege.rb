class Privilege < ApplicationRecord
  belongs_to :node

  enum role: { editor: 0, spender: 1 }

  validates :name, presence: true
  validates :node, presence: true
  validates :role, presence: true
end
