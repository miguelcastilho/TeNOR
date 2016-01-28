class CreateBreach < ActiveRecord::Migration
  def change
    create_table :breaches do |t|
      t.references :nsi_id, null: false
      t.integer :vnfi_id
      t.integer :nli_id
      t.integer :external_parameter_id, null: false
      t.float :value

      t.timestamps null: false
    end
  end
end


#VNF ID involved (if any)
#Network link involved (if any)
#Metric ID involved or description
#Associated value
