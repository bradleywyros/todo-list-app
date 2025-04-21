class List < ApplicationRecord
  self.table_name = 'list'
  has_many :items
  belongs_to :user
end
