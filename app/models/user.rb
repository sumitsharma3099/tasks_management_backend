class User < ApplicationRecord
    has_secure_password
    has_many :tasks
    validates :full_name, :email, presence: true
    validates :email, uniqueness: true

    # This function is used to fetch user tasks according to their status.
    def tasks_list(for_status, search_text, sort_by, sort_direction)
        sort_by = "created_at" if sort_by.blank? ||sort_by.nil?
        sort_direction = "ASC" if sort_direction.blank? ||sort_direction.nil?
        order_by_str = sort_by + " " + sort_direction
        for_status ||= "All"
        if search_text.present?
            if for_status == "All"
                self.tasks.where("title LIKE ? OR description LIKE ?", "%#{search_text}%", "%#{search_text}%").order(order_by_str)
            else
                self.tasks.where(status: for_status).where("title LIKE ? OR description LIKE ?", "%#{search_text}%", "%#{search_text}%").order(order_by_str)
            end
        else
            return self.tasks.order(order_by_str) if for_status == "All"
            self.tasks.where(status: for_status).order(order_by_str)
        end
    end
end
