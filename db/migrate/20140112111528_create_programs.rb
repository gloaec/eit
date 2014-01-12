class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :channel, index: true

      t.timestamps
    end
  end
end
