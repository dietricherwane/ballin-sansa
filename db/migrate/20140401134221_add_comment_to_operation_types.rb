class AddCommentToOperationTypes < ActiveRecord::Migration
  def change
    add_column :operation_types, :comment, :string
  end
end
