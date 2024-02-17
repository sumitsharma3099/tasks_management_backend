class Task < ApplicationRecord
    enum status: { "To Do": 1, "In Progress": 2, "Done": 3 }
    validates :title, :description, presence: true
    validates :title, length: { maximum: 500 }
    validates :description, length: { maximum: 200 }
    validate :validate_todo_limit, on: :create
    belongs_to :user
    

    def sort_title
      title.truncate(10)
    end
  
    def sort_description
      description.truncate(10)
    end

    private
  
    def validate_todo_limit
      # Count the number of existing "To Do" tasks
      todo_count = Task.where(status: 'To Do', user_id: user_id).count
  
      # Count the total number of tasks
      total_count = Task.where(user_id: user_id).count
  
      # Calculate the percentage of "To Do" tasks
      todo_percentage = (todo_count.to_f / total_count) * 100
  
      # Check if the condition is met
      if status == 'To Do' && todo_percentage >= 50
        errors.add(:base, 'Cannot create new "To Do" task. Limit reached.')
      end
    end
end
