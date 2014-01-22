class CreateMediaJoinTable < ActiveRecord::Migration
  def change
    create_join_table :channels, :ftps do |t|
      # t.index [:channel_id, :ftp_id]
      # t.index [:ftp_id, :channel_id]
    end
  end
end
