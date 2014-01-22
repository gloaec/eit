require 'net/ftp'

class Ftp < ActiveRecord::Base
  #include BCrypt
  belongs_to :channel
 
  def ping?
    ftp = nil
    begin 
      ftp = Net::FTP.new
      ftp.connect(self.host, self.port) 
      ftp.passive = self.passive || false
      return ftp.login self.user, self.password
    rescue
      return false
    ensure
      ftp.close unless ftp.nil?
    end
  end

  def password=(new_password)
    self.password_digest = AESCrypt.encrypt_data(new_password, self.secret, nil, "AES-256-ECB")
  end
  
  protected

  def password
    AESCrypt.decrypt_data(self.password_digest, self.secret, nil, "AES-256-ECB")
  end

  def secret
    Digest::SHA1.hexdigest(NrjEit::Application.config.secret_key_base)
  end
end
