class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :dni
      t.string :email
      t.string :address

      t.timestamps
    end
  end
end
