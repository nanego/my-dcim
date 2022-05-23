class AddCommentToServeurs < ActiveRecord::Migration[4.2]
  def change
    add_column :serveurs, :comment, :string
  end
end
