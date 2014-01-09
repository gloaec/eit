class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable, :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :channels
  has_many :admin_channels, class_name: 'ChannelAdmin'
  has_many :admins, through: :admin_channels, source: :channel
  has_many :contact_channels, class_name: 'ChannelContact'
  has_many :contacts, through: :contact_channels, source: :channel

  ROLES = %w[guest contact user admin superadmin]

  after_initialize :init

  def init
    self.role  ||= 'guest'
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

end
