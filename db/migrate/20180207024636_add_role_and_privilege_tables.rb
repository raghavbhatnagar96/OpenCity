class AddRoleAndPrivilegeTables < ActiveRecord::Migration[5.1]
  def change
  	add_column :worlds, :role_table, :json
  	add_column :worlds, :privilege_table, :json
  end
end
