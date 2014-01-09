class ChannelContact < ActiveRecord::Base
  self.table_name = "channels_contacts"
  belongs_to :channel
  belongs_to :user
end
