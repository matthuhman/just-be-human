class Role

  #
  # this creates a OpportunityRole with a level of 5 for the given user/opportunity
  # returns true if it saves successfully
  def self.follow_opportunity(u_id, opp_id)
    return unless OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id).nil?
    follow_role = OpportunityRole.new(user_id: u_id, opportunity_id: opp_id)

    follow_role.level = 5
    follow_role.title = "Follower"

    if follow_role.save
      Opportunity.increment_counter(:follower_count, opp_id)
      OpportunityMailer.follow_email(User.find(u_id), Opportunity.find(opp_id))
      true
    else
      ReportedError.report("Role.follow", follow_role.errors, 1000)
      false
    end
  end

  #
  # deletes a OpportunityRole if one exists for the given user/opportunity
  # returns true if a role exists and was deleted
  def self.unfollow_opportunity(u_id, opp_id)
    follow_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)
    return false unless follow_role

    if follow_role
      should_decrement_volunteer_count = false
      if follow_role.has_responded
        should_decrement_volunteer_count = true
        decrement_by = follow_role.additional_vols + 1
      else
        decrement_by = 0
      end

      follow_role.destroy

      Opportunity.decrement_counter(:follower_count, opp_id)
      if should_decrement_volunteer_count
        oppo = Opportunity.find(opp_id)
        oppo.volunteer_count -= decrement_by
        oppo.save
      end
    else
      ReportedError.report("Role.unfollow_opportunity", "framework logic error", 1000)
      false
    end
  end

  def self.rsvp(user, role, params)
    return false unless role

    oppo = role.opportunity

    first_response = !role.has_responded

    if !first_response
      old_addl_vols = role.additional_vols
      old_is_coming = role.is_coming
    else
      role.has_responded = true
    end

    role.is_coming = params[:is_coming] == "1" ? true : false
    role.additional_vols = params[:additional_vols]


    if first_response
      # if it's their first response, check to see if they're already a Volunteer
      # if they're not, mark them as such, and add their additional PLUS ONE for them
      # if they're already a volunteer, just add their additionals
      if role.is_coming && role.level == 5
        role.level = 4
        role.title = "Volunteer"
        oppo.volunteer_count += role.additional_vols + 1
      elsif role.is_coming
        oppo.volunteer_count += role.additional_vols
      end
    else
      # if this is not their first response, we're going to have to check whether they were
      # already RSVP'd or not
      # if they're now NOT coming, knock their level back to Follower, level to 5,
      # and remove them and their addl's from the volunteer count
      if !role.is_coming && old_is_coming
          role.level = 5
          role.title = "Follower"
          oppo.volunteer_count -= (role.additional_vols + 1)


        # if they now ARE coming and weren't before
        # if they do, just add addl vols, if they don't, level to 4, title to Volunteer
      elsif role.is_coming && !old_is_coming
          role.level = 4
          role.title = "Volunteer"
          oppo.volunteer_count += (role.additional_vols + 1)

        # if they ARE coming and were before, just compare the number of addl vols and
        # add or subtract as necessary
      elsif role.is_coming && old_is_coming
        if role.additional_vols > old_addl_vols
          oppo.volunteer_count += (role.additional_vols - old_addl_vols)
        elsif role.additional_vols < old_addl_vols
          oppo.volunteer_count -= (old_addl_vols - role.additional_vols)
        end
      end
    end

    oppo.opportunity_roles.each do |r|
      if r.user != role.user
        created = Notification.create(recipient: r.user, actor: role.user, action: "RSVP'd with #{role.additional_vols} people", notifiable: oppo)
        if !created
          ReportedError.report("Role.rsvp.createNotification", "did not successfully create notification", 2000)
        end
      end
    end

    role.save && oppo.save
  end


  #
  # creates a RequirementRole for a given user/requirement
  # sets the OpportunityRole level/title to 3/Volunteer if it isn't already
  # def self.volunteer(u_id, req_id, opp_id)
  #   return true if (RequirementRole.find_by(user_id: u_id, requirement_id: req_id))
  #   req_role = RequirementRole.new(user_id: u_id, requirement_id: req_id)
  #   opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)
  #   req_role.level = 2
  #   req_role.title = "Volunteer"
  #   req_role.requirement_id = req_id

  #   # if the user is currently a "follower", set their status to "volunteer"

  #   if opp_role.level > 3
  #     opp_role.level = 3
  #     opp_role.title = "Volunteer+"
  #     if !opp_role.save
  #       ReportedError.report("Role.volunteer_prob", opp_role.errors, 1000)
  #       return false
  #     end
  #     Opportunity.increment_counter(:volunteer_count, opp_id)
  #   end

  #   if req_role.save
  #     Requirement.find(req_id).add_volunteer
  #   else
  #     ReportedError.report("Role.volunteer_req", req_role.errors, 1000)
  #     false
  #   end
  # end


  # def self.cancel(u_id, req_id, opp_id)
  #   req_role = RequirementRole.find_by(user_id: u_id, requirement_id: req_id)
  #   if req_role
  #     req_role.destroy
  #     Requirement.find(req_id).subtract_volunteer
  #   else
  #     ReportedError.report("Role.cancel", "trying to cancel role that doesn't exist?? Framework logic error!!!", 1000)
  #     return false
  #   end

  #   if RequirementRole.where(user_id: u_id, requirement_id: req_id).size == 0
  #     opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)
  #     if opp_role.level > 3
  #       opp_role.level = 5
  #       opp_role.title = "Follower"
  #       if !opp_role.save
  #         ReportedError.report("Role.cancel", opp_role.errors, 1000)
  #         return false
  #       end
  #       Opportunity.decrement_counter(:volunteer_count, opp_id)
  #     end
  #   end

  #   true
  # end


  def self.set_opp_leader(outgoing_id, incoming_id, oppo)
    outgoing_role = OpportunityRole.find_by(user_id: outgoing_id, opportunity_id: oppo)
    return false unless outgoing_role&.level == 1

    incoming_role = OpportunityRole.find_by(user_id: incoming_id, opportunity_id: oppo)

    if outgoing_role.is_coming
      outgoing_role.level = 4
      outgoing_role.title = "Volunteer"
    else
      outgoing_role.level = 5
      outgoing_role.title = "Follower"
      Opportunity.decrement_counter(:volunteer_count, outgoing_role.opportunity)
    end

    incoming_role.level = 1
    incoming_role.title = "Leader"

    incoming_role.opportunity.user = incoming_role.user

    outgoing_role.save && incoming_role.save && incoming_role.opportunity.save
  end


  def self.make_opp_supervisor(u_id, opp_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)

    if opp_role
      if opp_role.level == 5
        increment_vol_counter = true
      end
      opp_role.level = 2
      opp_role.title = "Supervisor"

      if opp_role.save
        if increment_vol_counter
          Opportunity.increment_counter(:volunteer_count, opp_id)
        end
        true
      else
        ReportedError.report("Role.make_supervisor", opp_role.errors, 1000)
        false
      end
    else
      ReportedError.report("Role.make_opp_supervisor", "trying to promote opp_role that doesn't exist?? Framework logic error!!!", 1000)
      false
    end
  end


  def self.remove_opp_supervisor(u_id, opp_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)

    if opp_role
      opp_role.level = 5
      opp_role.title = "Follower"
      decrement_volunteer_counter = true

      if opp_role.save
        if decrement_volunteer_counter
          Opportunity.decrement_counter(:volunteer_count, opp_id)
        end
        true
      else
        ReportedError.report("Role.remove_supervisor", opp_role.errors, 1000)
        false
      end
    else
      ReportedError.report("Role.remove_opp_supervisor", "framework logic error", 1000)
      false
    end
  end



  def self.verify_self(u_id, opp_id, self_verification, is_leader_present)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)

    if opp_role
      opp_role.self_verified = self_verification
      opp_role.self_verified_at = Time.new

      if self_verification
        opp_role.leader_was_present = is_leader_present
      end

      opp_role.save

      Leaderboard.update(opp_role)
    else
      ReportedError.report("Role.verify_self", "framework logic error!! trying to verify role that doesn't exist", 1000)
      false
    end
  end



  def self.verify_user(u_id, opp_id, leader_verification)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)

    if opp_role
      opp_role.leader_verified = leader_verification
      opp_role.leader_verified_at = Time.new

      opp_role.save

      Leaderboard.update(opp_role)
    else
      ReportedError.report("Role.verify_user", "framework logic error!! trying to verify role that doesn't exist", 1000)
      false
    end
  end

end
