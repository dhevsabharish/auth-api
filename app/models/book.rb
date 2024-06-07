class Book < ApplicationRecord
    validates :title, presence: true
    validates :author, presence: true
    validates :publication_date, presence: true
    validates :genre, presence: true
    validates :availability_status, inclusion: { in: [true, false] }
  end
  