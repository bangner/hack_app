class BootcampInvitationMailer < ActionMailer::Base
  default from: '"John Reagan Moore" <johnreagan@hackapp.co>'
  def invite_bootcamp_admin(invitation)
    body = ""
    body += "<p>Hi #{invitation.bootcamp.name},</p>"
    body += "<p>hack_app is a site where students can research and apply to many different bootcamps, using our school directory and common application.</p>"
    body += "<p>We have created a profile for your school in our directory so that students can find and learn more about your school.  You can claim your school's listing to edit course info, descriptions, images and other content.  Managing school information is absolutely free and we encourage every school to take advantage of the free marketing.  So claim your invite, register, and keep your profile up to date.</p>"
    body += "<p><a href=\"" + new_bootcamp_admin_url(:bootcamp_id => invitation.bootcamp.id, :code => invitation.code).to_s + "\">Claim invitation here.</a></p>"
    body += "<p>We also offer a common application service to help you convert prospective student interest into applications and eventually students.  To learn more about the common application, register through the link above.</p>"
    mail(
      to: invitation.email,
      body: body,
      content_type: "text/html",
      subject: 'Invitation to hack_app')
  end
end