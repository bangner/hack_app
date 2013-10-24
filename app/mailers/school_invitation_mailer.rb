class SchoolInvitationMailer < ActionMailer::Base
  default from: 'stephen@hackapp.co'
  def invite_school_admin(email, code)
    mail(
      to: email,
      body: 'Welcome to hack_app. Click here ' + new_school_admin_url(:code => code) + '.',
      content_type: "text/html",
      subject: 'School Administration Invitation')
  end
end