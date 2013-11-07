class ApplicationMailer < ActionMailer::Base
  default from: '"Stephen Watkins" <stephen@hackapp.co>'
  def send_answers_to_school(admins, applicant, school_selection, answers)
    body = "<p>You were sent an application from <strong>#{applicant.name}</strong> with #{school_selection.school.name} as preference <strong>##{school_selection.priority}</strong>.</p>"
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