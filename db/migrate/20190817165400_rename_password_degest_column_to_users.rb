class RenamePasswordDegestColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :password_degest, :password_digest
  end
end
