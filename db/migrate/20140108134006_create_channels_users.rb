class CreateChannelsUsers < ActiveRecord::Migration
  def change
    create_table :channels_users do |t|
      t.references :channel, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
