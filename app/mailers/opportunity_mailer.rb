class OpportunityMailer < ApplicationMailer
  default from: 'mailer@justbehuman.io'

  def follow_email(user, opportunity)
    @user = user
    @opportunity = opportunity
    @cal = build_ical_file(opportunity)

    mail.attachments['opportunity.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: user.email, subject: "Add #{opportunity.title} to your calendar!")
  end


  private

    def build_ical_file(oppo)
      cal = Icalendar::Calendar.new

      cal.event do |e|
        e.dtstart = oppo.target_completion_date
        e.summary = oppo.title
        e.description = oppo.description
        e.location = oppo.address
        e.url = "https://justbehuman.io/opportunities/#{oppo.id}"
      end
    end
end
