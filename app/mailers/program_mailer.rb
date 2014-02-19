class ProgramMailer < ActionMailer::Base
  default from: "tektv@nrj.fr"
  layout 'mail'

  def default_url_options
    ActionMailer::Base.default_url_options = {:host => 'nrjtv-eit.nrjtv.fr'}
  end

  def success_notification(user, program)
    @program = program
    @user = user
    mail(:to => user.email, :subject => "[#{program.channel.name} - EIT] Success \"#{program.xml_file_name}\"").deliver
  end

  def error_notification(user, program)
    @program = program
    @user = user
    mail(:to => user.email, :subject => "[#{program.channel.name} - EIT] Error \"#{program.xml_file_name}\"").deliver
  end
end
