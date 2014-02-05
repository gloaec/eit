class CreateChannelsErrorContacts < ActiveRecord::Migration
  def change
    create_table :channels_error_contacts do |t|
      t.references :channel, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
