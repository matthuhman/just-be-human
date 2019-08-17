class MilestoneCategory

    #
    # get all keys methods
  def self.all_category_ids
    return categories.keys
  end

  def self.all_labor_subcat_ids
    return labor_subcats.keys
  end

  def self.all_planning_subcat_ids
    return planning_subcats.keys
  end

  def self.all_equipment_subcat_ids
    return equipment_subcats.keys
  end


  #
  # lookup methods
  def self.lookup_category(id)
    return categories[id]
  end

  def self.lookup_planning_subcat(id)
    return planning_subcats[id]
  end

  def self.lookup_labor_subcat(id)
    return labor_subcats[id]
  end

  def self.lookup_equipment_subcat(id)
    return equipment_subcats[id]
  end


  
    # map of integer ID's to categories
    categories = 
    {
      1 => {:title => "Planning", :desc => "Have things that still need to be figured out? Schedule some time to do it. Prior Planning Prevents Piss Poor Performance!"}, 
      2 => {:title => "Labor", :desc => "Once you've figured out what needs doing, find volunteers to get it done."}, 
      3 => {:title => "Equipment", :desc => "Make sure that any equipment you need is located ahead of time, so it's there when you need it."},
      4 => {:title => "Transportation", :desc => "Find volunteers with vehicles who can help you get where you need to be!"}
    }

    planning_subcats = 
    {
      1 => {:title => "In-person", :desc => "Trying to make plans as a group? In-person is always better."},
      2 => {:title => "Remote", :desc => "Remote planning is great for when small decisions need to be made quickly!"}
    }

    labor_subcats = 
    {
      1 => {:title => "Light labor", :desc => "This should be well within the physical capabilities of an average person."},
      2 => {:title => "Heavy labor", :desc => "If you need someone who can pick up and move around 50+ lbs"},
      3 => {:title => "Specialized labor", :desc => "If you need a someone with a specialized skill, but it's okay if they're not a professional."},
      4 => {:title => "Professional labor", :desc => "This task can only be handled by a professional. Keep in mind that you'll probably still need to pay them!"}
    }

    equipment_subcats = 
    {
      1 => {:title => "Household items", :desc => "If you need "},
      2 => {:title => "Lawn and garden", :desc => "asdf"},
      3 => {:title => "Hand tools", :desc => "asdf2"}
      4 => {:title => "Specialized tools", :desc => ""},
      5 => {:title => "Custom built/ordered", :desc => "Are you going to need something custom-made? Define it here."},
      6 => {:title => "Heavy equipment", :desc => "Examples: a stump grinder, jackhammer, backhoe, etc"},
      8 => {:title => "Food", :desc => ""}
    }

end