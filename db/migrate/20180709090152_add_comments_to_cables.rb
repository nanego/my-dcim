class AddCommentsToCables < ActiveRecord::Migration[5.1]
  def change
    add_column :cables, :comments, :string
    add_column :cables, :special_case, :boolean
  end
end
