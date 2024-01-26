class User < ApplicationRecord
    has_secure_password
    has_many :tasks
    validates :full_name, :email, presence: true
    validates :email, uniqueness: true

    def tasks_list(for_status = "All")
        return self.tasks if for_status == "All"
        self.tasks.where(status: for_status)
    end
end
