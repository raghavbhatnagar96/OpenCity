class AddFieldsInResources < ActiveRecord::Migration[5.1]
  def change
  	add_column :resources, :title, :string, :null => false, :default => ''
  	add_column :resources, :uploads, :string
  end
end
