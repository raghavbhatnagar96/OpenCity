class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
  	change_table :users do |t|
      t.belongs_to :world, index: true
  	  # t.string :name
  	  t.text :description
    end
  end
end
