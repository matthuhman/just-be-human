class Role


  #
  # this creates a ProblemRole with a level of 4 for the given user/problem
  # returns true if it saves successfully
  def self.follow_problem(u_id, p_id)
    follow_role = ProblemRole.new(user_id: u_id, problem_id: p_id)

    follow_role.level = 4
    follow_role.title = "Follower"

    if follow_role.save
      Problem.increment_counter(:follower_count, p_id)
      return true
    else
      ReportedError.report("Role.follow", follow_role.errors, 1000)
      return false
    end
  end

  #
  # deletes a ProblemRole if one exists for the given user/problem
  # returns true if a role exists and was deleted
  def self.unfollow_problem(u_id, p_id)
    follow_role = ProblemRole.find_by(user_id: u_id, problem_id: p_id)

    if follow_role
      follow_role.destroy
      Problem.decrement_counter(:follower_count, p_id)
      return true
    else
      puts "We shouldn't have been able to get here! Unfollow problem for user: #{u_id} and problem: #{p_id}"
      return false
    end
  end


  #
  # creates a MilestoneRole for a given user/milestone
  # sets the ProblemRole level/title to 3/Volunteer if it isn't already
  def self.volunteer(u_id, ms_id, p_id)
    ms_role = MilestoneRole.new(user_id: u_id, milestone_id: ms_id)
    prob_role = ProblemRole.find_by(user_id: u_id, problem_id: p_id)
    ms_role.level = 2
    ms_role.title = "Volunteer"
    ms_role.problem_id = p_id

    # if the user is currently a "follower", set their status to "volunteer"
    if prob_role.level == 4
      prob_role.level = 3
      prob_role.title = "Volunteer"
      if !prob_role.save
        ReportedError.report("Role.volunteer_prob", prob_role.errors, 1000)
        return false
      end
    end

    if ms_role.save
      Problem.increment_counter(:volunteer_count, p_id)
      Milestone.increment_counter(:volunteer_count, ms_id)
      return true
    else
      ReportedError.report("Role.volunteer_ms", ms_role.errors, 1000)
      return false
    end
  end


  def self.cancel(u_id, ms_id, p_id)
    ms_role = MilestoneRole.find_by(user_id: u_id, milestone_id: ms_id)
    if ms_role
      ms_role.destroy
      Milestone.decrement_counter(:volunteer_count, ms_id)
    else
      ReportedError.report("Role.cancel", "trying to cancel role that doesn't exist?? Framework logic error!!!", 1000)
      return false
    end

    if MilestoneRole.where(user_id: u_id, problem_id: p_id).size == 0
      prob_role = ProblemRole.find_by(user_id: u_id, problem_id: p_id)
      if prob_role.level > 2
        prob_role.level = 4
        prob_role.title = "Follower"
        if !prob_role.save
          ReportedError.report("Role.cancel", prob_role.errors, 1000)
          return false
        end
        Problem.decrement_counter(:volunteer_count, p_id)
      end
    end

    return true
  end


  def self.make_supervisor(u_id, p_id)
    prob_role = ProblemRole.find_by(user_id: u_id, problem_id: p_id)

    if prob_role
      if prob_role.level == 4
        increment_vol_counter = true
      end
      prob_role.level = 2
      prob_role.title = "Supervisor"
      
      if prob_role.save
        if increment_vol_counter
          Problem.increment_counter(:volunteer_count, p_id)
        end
        return true
      else
        ReportedError.report("Role.make_supervisor", prob_role.errors, 1000)
        return false
      end
    else
      ReportedError.report("Role.make_supervisor", "trying to promote prob_role that doesn't exist?? Framework logic error!!!", 1000)
      return false
    end
  end


  def self.remove_supervisor(u_id, p_id)
    prob_role = ProblemRole.find_by(user_id: u_id, problem_id: p_id)

    if prob_role
      if MilestoneRole.where(user_id: u_id, problem_id: p_id).size == 0
        prob_role.level = 4
        prob_role.title = "Follower"
        decrement_volunteer_counter = true
      else
        prob_role.level = 3
        prob_role.title = "Volunteer"
      end

      if prob_role.save
        if decrement_volunteer_counter
          Problem.decrement_counter(:volunteer_count, p_id)
        end
        return true
      else
        ReportedError.report("Role.remove_supervisor", prob_role.errors, 1000)
        return false
      end
    else
      ReportedError.report("Role.remove_supervsior", "framework logic error", 1000)
      return false
    end
  end


  def set_problem_leader(u_id, p_id)



  end


  def set_ms_leader(u_id, ms_id)



  end


  def remove_ms_leader(u_id, ms_id)



  end
  

  def problem_role_level(u_id, p_id)




  end


  def milestone_role_level(u_id, ms_id)




  end




























end