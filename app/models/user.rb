class User < ApplicationRecord
    has_secure_password
    has_many :tasks
    validates :full_name, :email, :password, presence: true
    validates :email, uniqueness: true
    validates :full_name, length: { maximum: 20 }
    validates :email, length: { maximum: 25 }
    validates :profile_pic_url, length: { maximum: 300 }


    # This function is used to fetch user tasks according to their status.
    def tasks_list(for_status, search_text)
        for_status ||= "All"
        if search_text.present?
            if for_status == "All"
                self.tasks.where("title LIKE ? OR description LIKE ?", "%#{search_text}%", "%#{search_text}%")
            else
                self.tasks.where(status: for_status).where("title LIKE ? OR description LIKE ?", "%#{search_text}%", "%#{search_text}%")
            end
        else
            return self.tasks if for_status == "All"
            self.tasks.where(status: for_status)
        end
    end
end
