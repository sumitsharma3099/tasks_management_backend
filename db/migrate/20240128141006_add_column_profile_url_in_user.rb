class AddColumnProfileUrlInUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :profile_pic_url, :string, default: "https://i.stack.imgur.com/l60Hf.png"
  end
end
