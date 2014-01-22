class Channel < ActiveRecord::Base
  has_and_belongs_to_many :ftps
  has_and_belongs_to_many :users
  has_many :channel_admins, class_name: 'ChannelAdmin'
  has_many :admins, through: :channel_admins, source: :user
  has_many :channel_contacts, class_name: 'ChannelContact'
  has_many :contacts, through: :channel_contacts, source: :user
  has_many :programs

  accepts_nested_attributes_for :ftps, :allow_destroy => true
end
