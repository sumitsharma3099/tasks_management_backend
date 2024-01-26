class Task < ApplicationRecord
    enum status: { "To Do": 1, "In Progress": 2, "Done": 3 }
    validates :title, :description, presence: true
    belongs_to :user
end
