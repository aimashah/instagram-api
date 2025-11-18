class RenameContentToTextInComments < ActiveRecord::Migration[8.1]
  def change
  rename_column :comments, :content, :text
  end

end
