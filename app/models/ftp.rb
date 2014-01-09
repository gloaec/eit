class Ftp < ActiveRecord::Base
  include BCrypt

  belongs_to :channel

  def password
    @password ||= Password.new(password_hash)
  end
  
  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

end
