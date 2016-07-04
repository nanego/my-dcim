class AddCommentToServeurs < ActiveRecord::Migration
  def change
    add_column :serveurs, :comment, :string
  end
end
