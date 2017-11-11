class Topic < ApplicationRecord
    validates :title, presence: true, length: { minimum: 3 }

    has_many :posts
end
