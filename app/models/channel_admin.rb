class ChannelAdmin < ActiveRecord::Base
  self.table_name = "channels_admins"
  belongs_to :channel
  belongs_to :user
end
