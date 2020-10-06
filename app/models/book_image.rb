class BookImage < ApplicationRecord
  belongs_to :book
  attachment :image
end
