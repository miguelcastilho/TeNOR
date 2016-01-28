class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.string :formula, null: false

      t.belongs_to :sla, index: true
      t.timestamps null: false
    end

#    add_index :parameters, :name, unique: true
  end
end
