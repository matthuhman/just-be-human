class OpportunityMailer < ApplicationMailer
  default from: 'mailer@justbehuman.io'

  def follow_email(user, opportunity)
    @user = user
    @opportunity = opportunity
    @cal = build_ical_file(opportunity)

    mail.attachments['cleanup.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    @opportunity.waivers.each do |w|
      mail.attachments[w.file_name] = { mime_type: w.file_type, content: w.waiver_file }
    end
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
        e.url = "https://detrashers.org/opportunities/#{oppo.id}"
      end
    end
end
