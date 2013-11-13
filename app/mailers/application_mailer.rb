class ApplicationMailer < ActionMailer::Base
  default from: '"John Reagan Moore" <johnreagan@hackapp.co>'
  def send_profile_to_bootcamp(admins, applicant, selection, answers)
    body = "<p>You were sent an application from <strong>#{applicant.name}</strong> with #{selection.bootcamp.name} as preference <strong>##{selection.priority}</strong>.</p>"

    body += "<p><strong>Applicant Account</strong></p>"

    body += "<p><strong>Name</strong></p>"
    body += "<p>#{applicant.name}</p>"
    body += "<p><strong>Email</strong></p>"
    body += "<p>#{applicant.email}</p>"

    body += "<p><strong>Applicant Profile</strong></p>"

    answers.each do |answer|
      body += "<p>"
      body += "<strong>" + answer.question.label.to_s + "</strong><br />"
      body += answer.answer
      body += "</p>"
    end

    mail(
      to: admins.pluck(:email),
      body: body,
      content_type: "text/html",
      subject: 'Application from ' + applicant.name
    )
  end
end