class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :queue_path
      t.string :success_path
      t.string :error_path
      t.string :ftp_path
      t.timestamps
    end
  end
end
