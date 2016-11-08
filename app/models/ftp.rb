require 'net/ftp'

class Ftp < ActiveRecord::Base
  has_many :ftp_channels, class_name: 'ChannelFtp', dependent: :destroy
  has_many :channels, through: :ftp_channels, source: :channel

  def ping?
    case self.protocol
    when 'ftp'
      puts "Pinging FTP..."
      ftp = nil
      begin
        ftp = Net::FTP.new
        Timeout.timeout(10) do
          ftp.connect(self.host, self.port)
          ftp.passive = self.passive || false
          ftp.login self.user, self.password
        end
      rescue
        false
      ensure
        ftp.close unless ftp.nil?
      end
    when 'sftp'
      puts "Pinging SFTP..."
      begin
        session, sftp = nil, nil
        Timeout.timeout(10) do
          session = Net::SSH.start(self.host, self.user, password: self.password, port: self.port)
          sftp = Net::SFTP::Session.new(session)
          sftp.connect!
          sftp.open?
        end
      rescue Timeout::Error => e
        false
      ensure
        sftp.close_channel unless sftp.nil?
        session.close unless session.nil?
        Timeout.timeout(10) do
          sleep 1 until (sftp.nil? or sftp.closed?) and (session.nil? or session.closed?)
        end
      end
    else
      false
    end
  end

  def password=(new_password)
    if new_password.blank?
      #self.password_digest = ""
    else
      self.password_digest = AESCrypt.encrypt_data(new_password, self.secret, nil, "AES-256-ECB")
    end
  end

  def password
    if self.password_digest.blank?
      ""
    else
      AESCrypt.decrypt_data(self.password_digest, self.secret, nil, "AES-256-ECB")
    end
  end

  protected

  def secret
    Digest::SHA1.hexdigest(NrjEit::Application.config.secret_key_base)
  end
end
