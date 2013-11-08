class ApplicationMailer < ActionMailer::Base
  default from: '"John Reagan Moore" <johnreagan@hackapp.co>'
  def send_answers_to_school(admins, applicant, school_selection, answers)
    body = "<p>You were sent an application from <strong>#{applicant.name}</strong> with #{school_selection.school.name} as preference <strong>##{school_selection.priority}</strong>.</p>"

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