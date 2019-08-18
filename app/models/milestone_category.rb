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
  def self.categories
    [
      {:id => 0, :title => "Planning", :desc => "Have things that still need to be figured out? Schedule some time to do it. Prior Planning Prevents Piss Poor Performance!"},
      {:id => 1, :title => "Labor", :desc => "Once you've figured out what needs doing, find volunteers to get it done."},
      {:id => 2, :title => "Equipment", :desc => "Make sure that any equipment you need is located ahead of time, so it's there when you need it."},
      {:id => 3, :title => "Transportation", :desc => "Find volunteers with vehicles who can help you get where you need to be!"}
    ]
  end


  def self.sub_categories
    {
      0 => [ # planning
        {:id => 0, :title => "In-person", :desc => "Trying to make plans as a group? In-person is always better."},
        {:id => 1, :title => "Remote", :desc => "Remote planning is great for when small decisions need to be made quickly!"}
      ],
      1 => [ # labor
        {:id => 0, :title => "Light labor", :desc => "This should be well within the physical capabilities of an average person."},
        {:id => 1, :title => "Heavy labor", :desc => "If you need someone who can pick up and move around 50+ lbs"},
        {:id => 2, :title => "Specialized labor", :desc => "If you need a someone with a specialized skill, but it's okay if they're not a professional."},
        {:id => 3, :title => "Professional labor", :desc => "This task can only be handled by a professional. Keep in mind that you'll probably still need to pay them!"}
      ],
      2 => [ # equipment
        {:id => 0, :title => "Household items", :desc => "If you need "},
        {:id => 1, :title => "Lawn and garden", :desc => "asdf"},
        {:id => 2, :title => "Hand tools", :desc => "asdf2"},
        {:id => 3, :title => "Specialized tools", :desc => ""},
        {:id => 4, :title => "Custom built/ordered", :desc => "Are you going to need something custom-made? Define it here."},
        {:id => 5, :title => "Heavy equipment", :desc => "Examples: a stump grinder, jackhammer, backhoe, etc"},
        {:id => 6, :title => "Food", :desc => ""}
      ],
      3 => [ #Transportation
        {:id => 0, :title => "Large Vehicle", :desc => "Need large vehicle for transporting lots of people and/or equipment"},
        {:id => 1, :title => "Medium Vehicle", :desc => "Need medium vehicle for transporting a few people and/or equipment"},
        {:id => 2, :title => "Small Vehicle", :desc => "Need medium vehicle for transporting small amount of people and/or equipment"},
      ]
    }
  end
end
