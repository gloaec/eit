class ProgramMailer < ActionMailer::Base
  default from: "ghis182@gmail.com"
  layout 'mail'

  def success_notification(user, program)
    @program = program
    @user = user
    mail(:to => user.email, :subject => "[NRJ-EIT] Successful processing \"#{program.xml_file_name}\"").deliver
  end

  def error_notification(user, program)
    @program = program
    @user = user
    mail(:to => user.email, :subject => "[NRJ-EIT] Error processing \"#{program.xml_file_name}\"").deliver
  end
end
