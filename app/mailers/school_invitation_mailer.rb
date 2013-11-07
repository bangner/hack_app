class SchoolInvitationMailer < ActionMailer::Base
  default from: '"John Reagan Moore" <johnreagan@hackapp.co>'
  def invite_school_admin(email, school_id, code)
    mail(
      to: email,
      body: 'Welcome to hack_app. Click here ' + new_school_admin_url(:school_id => school_id, :code => code) + '.',
      content_type: "text/html",
      subject: 'School Administration Invitation')
  end
end