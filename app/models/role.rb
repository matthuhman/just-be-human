class Role

  #
  # this creates a OpportunityRole with a level of 4 for the given user/opportunity
  # returns true if it saves successfully
  def self.follow_opportunity(u_id, opp_id)
    follow_role = OpportunityRole.new(user_id: u_id, opportunity_id: opp_id)

    follow_role.level = 4
    follow_role.title = "Follower"

    if follow_role.save
      Opportunity.increment_counter(:follower_count, opp_id)
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

    if follow_role
      follow_role.destroy
      should_decrement_volunteer_count = false
      Opportunity.find(opp_id).requirements.each do |req|
        role = RequirementRole.find_by(user_id: u_id, requirement_id: req.id)
        if role
          role.destroy
          should_decrement_volunteer_count = true
        end
      end

      Opportunity.decrement_counter(:follower_count, opp_id)
      Opportunity.decrement_counter(:volunteer_count, opp_id) if should_decrement_volunteer_count?
      true
    else
      ReportedError.report("Role.unfollow_opportunity", "framework logic error", 1000)
      false
    end
  end


  #
  # creates a RequirementRole for a given user/requirement
  # sets the OpportunityRole level/title to 3/Volunteer if it isn't already
  def self.volunteer(u_id, req_id, opp_id)
    return true if (RequirementRole.find_by(user_id: u_id, requirement_id: req_id))
    req_role = RequirementRole.new(user_id: u_id, requirement_id: req_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)
    req_role.level = 2
    req_role.title = "Volunteer"
    req_role.requirement_id = req_id

    # if the user is currently a "follower", set their status to "volunteer"

    if opp_role.level == 4
      opp_role.level = 3
      opp_role.title = "Volunteer"
      if !opp_role.save
        ReportedError.report("Role.volunteer_prob", opp_role.errors, 1000)
        return false
      end
      Opportunity.increment_counter(:volunteer_count, opp_id)
    end

    if req_role.save
      Requirement.find(req_id).add_volunteer
    else
      ReportedError.report("Role.volunteer_req", req_role.errors, 1000)
      false
    end
  end


  def self.cancel(u_id, req_id, opp_id)
    req_role = RequirementRole.find_by(user_id: u_id, requirement_id: req_id)
    if req_role
      req_role.destroy
      Requirement.find(req_id).subtract_volunteer
    else
      ReportedError.report("Role.cancel", "trying to cancel role that doesn't exist?? Framework logic error!!!", 1000)
      return false
    end

    if RequirementRole.where(user_id: u_id, requirement_id: req_id).size == 0
      opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)
      if opp_role.level > 2
        opp_role.level = 4
        opp_role.title = "Follower"
        if !opp_role.save
          ReportedError.report("Role.cancel", opp_role.errors, 1000)
          return false
        end
        Opportunity.decrement_counter(:volunteer_count, opp_id)
      end
    end

    true
  end


  def self.make_opp_supervisor(u_id, opp_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)

    if opp_role
      if opp_role.level == 4
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
      ReportedError.report("Role.make_supervisor", "trying to promote opp_role that doesn't exist?? Framework logic error!!!", 1000)
      false
    end
  end


  def self.make_req_leader(u_id, req_id)
    req_role = RequirementRole.find_by(user_id: u_id, requirement_id: req_id)

    # can only have one leader per requirement- if one exists, do not appoint new one
    if RequirementRole.find_by(requirement_id: req_id, level: 1)
      return false
    end

    if req_role
      req_role.level = 1
      req_role.title = "Leader"

      req_role.save
    end
  end


  def self.remove_req_leader(req_id)
    req_role = RequirementRole.find_by(requirement_id: req_id, level: 1)

    if req_role
      req_role.level = 2
      req_role.title = "Volunteer"

      req_role.save
    end
  end


  def self.remove_opp_supervisor(u_id, opp_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: opp_id)

    if opp_role
      if RequirementRole.where(user_id: u_id, opportunity_id: opp_id).size == 0
        opp_role.level = 4
        opp_role.title = "Follower"
        decrement_volunteer_counter = true
      else
        opp_role.level = 3
        opp_role.title = "Volunteer"
      end

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
      ReportedError.report("Role.remove_supervisor", "framework logic error", 1000)
      false
    end
  end
end
