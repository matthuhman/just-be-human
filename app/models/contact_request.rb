class ContactRequest < ApplicationRecord

  belongs_to :requesting_user, :class_name => 'User'
  belongs_to :requested_user, :class_name => 'User'


  def self.get_active_requests_for_opportunity(user_id, opp_id)
    return ContactRequest.find_by(requesting_user_id: user_id, opportunity_id: opp_id, active: true)
  end


  def self.send_contact_request(out_user, in_user, opp_id)
    old_req = ContactRequest.find_by(requesting_user_id: out_user.id, requested_user_id: in_user.id)

    if old_req
      return true
    end

    req = ContactRequest.new(requesting_user_id: out_user.id, requested_user_id: in_user.id, opportunity_id: opp_id)

    if out_user.over_16? && in_user.over_16? && Opportunity.users_are_volunteers(out_user.id, in_user.id, opp_id)


      if req.save
        return true
      else
        ReportedError.report("ContactRequest.saving_good_request", req.errors, 1000)
        return false
      end
    else

      req.accepted = false

      if req.save
        return true
      else
        ReportedError.report("ContactRequest.saving_bad_request", req.errors, 1000)
        return false
      end
    end
  end


  def self.contact_response(cr_id, accepted)
    req = ContactRequest.find(cr_id)
    req.response_time = Time.now
    if accepted
      req.accepted = true
      req.accept_time = Time.now
      req.active = true

      if req.save
        return true
      else
        ReportedError.report("ContactRequest.save_accepted_response", req.errors, 1000)
        return false
      end
    else
      req.active = true
      req.accepted = false
      if req.save
        return true
      else
        ReportedError.report("ContactRequest.save_declined_response", req.errors, 1000)
        return false
      end
    end
  end
end
