class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.integer :minimum_age
      t.datetime :start_time
      t.datetime :end_time
      t.integer :position
      t.references :program, index: true

      t.timestamps
    end
  end
end
