class CreateResources < ActiveRecord::Migration[5.1]
  def change
    create_table :resources do |t|
      t.date :date_published
      t.text :description

      t.timestamps
    end
  end
end
