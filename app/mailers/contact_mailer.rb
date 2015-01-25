class ContactMailer < ActionMailer::Base
  	default from: "TC Bad Essen Platzbelegungsplan-Software-Team <team@tc-bad-essen.de>"

  	def send_contact_form(name,mail,subject,message)
  		@name = name
        @mail_address = mail
        @subject = subject
        @message = message
        mail_subject = "Kontaktformular - " + subject
  		mail(to: "julius.rueckin@gmail.com", subject: mail_subject)
  	end

end