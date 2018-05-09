class CreateWorlds < ActiveRecord::Migration[5.1]
  def change
    create_table :worlds do |t|
      t.string :title, null: false, index: {unique: true}
      t.timestamps
    end
  end
end
