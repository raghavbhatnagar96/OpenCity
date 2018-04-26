class AddLocationToWorld < ActiveRecord::Migration[5.1]
  def change
  	change_table :worlds do |t|
      t.belongs_to :world, :location, index: true
    end
  end
end
