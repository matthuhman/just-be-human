class Role

  #
  # this creates a OpportunityRole with a level of 4 for the given user/opportunity
  # returns true if it saves successfully
  def self.follow_opportunity(u_id, p_id)
    follow_role = OpportunityRole.new(user_id: u_id, opportunity_id: p_id)

    follow_role.level = 4
    follow_role.title = "Follower"

    if follow_role.save
      Opportunity.increment_counter(:follower_count, p_id)
      return true
    else
      ReportedError.report("Role.follow", follow_role.errors, 1000)
      return false
    end
  end

  #
  # deletes a OpportunityRole if one exists for the given user/opportunity
  # returns true if a role exists and was deleted
  def self.unfollow_opportunity(u_id, p_id)
    follow_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: p_id)

    if follow_role
      follow_role.destroy
      Opportunity.decrement_counter(:follower_count, p_id)
      return true
    else
      ReportedError.report("Role.unfollow_opportunity", "framework logic error", 1000)
      return false
    end
  end


  #
  # creates a RequirementRole for a given user/requirement
  # sets the OpportunityRole level/title to 3/Volunteer if it isn't already
  def self.volunteer(u_id, req_id, p_id)
    return true if (RequirementRole.find_by(user_id: u_id, requirement_id: req_id))
    req_role = RequirementRole.new(user_id: u_id, requirement_id: req_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: p_id)
    req_role.level = 2
    req_role.title = "Volunteer"
    req_role.opportunity_id = p_id

    # if the user is currently a "follower", set their status to "volunteer"

    if opp_role.level == 4
      opp_role.level = 3
      opp_role.title = "Volunteer"
      if !opp_role.save
        ReportedError.report("Role.volunteer_prob", opp_role.errors, 1000)
        return false
      end
      Opportunity.increment_counter(:volunteer_count, p_id)
    end

    if req_role.save
      Requirement.increment_counter(:volunteer_count, req_id)
      true
    else
      ReportedError.report("Role.volunteer_req", req_role.errors, 1000)
      false
    end
  end


  def self.cancel(u_id, req_id, p_id)
    req_role = RequirementRole.find_by(user_id: u_id, requirement_id: req_id)
    if req_role
      req_role.destroy
      Requirement.decrement_counter(:volunteer_count, req_id)
    else
      ReportedError.report("Role.cancel", "trying to cancel role that doesn't exist?? Framework logic error!!!", 1000)
      return false
    end

    if RequirementRole.where(user_id: u_id, opportunity_id: p_id).size == 0
      opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: p_id)
      if opp_role.level > 2
        opp_role.level = 4
        opp_role.title = "Follower"
        if !opp_role.save
          ReportedError.report("Role.cancel", opp_role.errors, 1000)
          return false
        end
        Opportunity.decrement_counter(:volunteer_count, p_id)
      end
    end

    true
  end


  def self.make_supervisor(u_id, p_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: p_id)

    if opp_role
      if opp_role.level == 4
        increment_vol_counter = true
      end
      opp_role.level = 2
      opp_role.title = "Supervisor"

      if opp_role.save
        if increment_vol_counter
          Opportunity.increment_counter(:volunteer_count, p_id)
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


  def self.remove_supervisor(u_id, p_id)
    opp_role = OpportunityRole.find_by(user_id: u_id, opportunity_id: p_id)

    if opp_role
      if RequirementRole.where(user_id: u_id, opportunity_id: p_id).size == 0
        opp_role.level = 4
        opp_role.title = "Follower"
        decrement_volunteer_counter = true
      else
        opp_role.level = 3
        opp_role.title = "Volunteer"
      end

      if opp_role.save
        if decrement_volunteer_counter
          Opportunity.decrement_counter(:volunteer_count, p_id)
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

  def self.opportunity_role_title(u_id, p_id)
    role = OpportunityRole.find_by(user_id: u_id, opportunity_id: p_id)

    if role
      role.title
    end
  end


  def self.opportunity_role_level(u_id, p_id)
    role = OpportunityRole.find_by(user_id: u_id, opportunity_id: p_id)

    if role
      role.level
    end
  end


  def self.requirement_role_level(u_id, req_id)
    role = RequirementRole.find_by(user_id: u_id, requirement_id: req_id)

    if role
      role.level
    end
  end




























end
