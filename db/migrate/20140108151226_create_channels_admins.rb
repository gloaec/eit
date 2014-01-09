class CreateChannelsAdmins < ActiveRecord::Migration
  def change
    create_table :channels_admins do |t|
      t.references :channel, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
