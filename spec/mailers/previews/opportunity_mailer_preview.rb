# Preview all emails at http://localhost:3000/rails/mailers/opportunity_mailer
class OpportunityMailerPreview < ActionMailer::Preview

  def follow_email
    OpportunityMailer.follow_email(User.first, Opportunity.first)
  end
end
