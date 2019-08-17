class Category



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




  private

  
    # map of integer ID's to categories
    categories = 
    {
      1 => "Planning", 
      2 => "Labor", 
      3 => "Equipment",
      4 => "Transportation"
    }

    planning_subcats = 
    {
      1 => "In-person",
      2 => "Remote"
    }

    labor_subcats = 
    {
      1 => "Light labor", 
      2 => "Heavy labor", 
      3 => "Specialized labor", 
      4 => "Licensed labor"
    }

    equipment_subcats = 
    {
      1 => "Household items",
      2 => "Lawn and garden",
      3 => "Hand tools",
      4 => "Specialized tools",
      5 => "Custom built/ordered",
      6 => "Heavy equipment (Indoor)",
      7 => "Heavy equipment (Outdoor)"
    }

end