class CreateViolations < ActiveRecord::Migration
  def change
  	create_table :violations do |t|
  		t.integer :breaches_count, null: false
  		t.integer :interval, null: false

  		t.belongs_to :parameter, index: true
  		t.timestamps null: false
  	end
  end
end