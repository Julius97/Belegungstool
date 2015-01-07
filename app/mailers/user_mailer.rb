class UserMailer < ActionMailer::Base
	default from: "TC Bad Essen Platzbelegungsplan-Software-Team <team@tc-bad-essen.de>"
    
    def forgot_password(user)
    	@user = user
        mail to: user.mail_address, subject: "Passwort vergessen - Neues Passwort"
    end

end
