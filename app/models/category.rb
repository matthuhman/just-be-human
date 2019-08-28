class Category

  #
  # get all category titles
  def self.problem_titles
    return self.problem_cats.map { |c| c[:title] }
  end

  #
  # get all category titles with descriptions
  def self.problem_titles_with_desc
    return self.problem_cats
  end

  #
  # get all subcategory titles for a given category id
  def self.problem_subcat_titles(cat_id)
    self.problem_subcats[cat_id].map { |sc| sc[:title] }
  end

  #
  # get all subcat titles and descriptions for a given category id
  def self.problem_subcat_titles_with_desc(cat_id)
    return self.problem_subcats[cat_id]
  end

  def self.req_titles
    return self.req_cats.map { |c| c[:title] }
  end

  #
  # get all category titles with descriptions
  def self.req_titles_with_desc
    return self.req_cats
  end

  #
  # get all subcategory titles for a given category id
  def self.req_subcat_titles(cat_id)
    self.req_subcats[cat_id].map { |sc| sc[:title] }
  end

  #
  # get all subcat titles and descriptions for a given category id
  def self.req_subcat_titles_with_desc(cat_id)
    return self.req_subcats[cat_id]
  end

  def self.get_all_problem_subcats
    self.problem_subcats
  end



  private

  # map of integer ID's to categories
  def self.problem_cats
    [
      # the index is the category ID- ORDER IS IMPORTANT!
      { title: "Community Cleanup", desc: "Community cleanup description" },
      { title: "Fundraising", desc: "Fundraising description" },
      { title: "Outreach", desc: "Outreach description" }
    ]
  end

  # map of Problem category index to subcategory arrays
  def self.problem_subcats
    [
      [ # community cleanup
        { title: "Trash pickup", desc: "Pick up some trash, damnit!" },
        { title: "Property maintenance", desc: "There's a property in my neighborhood that needs to be cleaned up!" }
      ],
      [ # labor
        { title: "For a person", desc: "For a person in need." },
        { title: "For a cause", desc: "For a cause that you care about."},
        { title: "For an organization", desc: "For an organization that needs the help!" }
      ],
      [ # equipment
        { title: "Food drive", desc: "Collect food for a cause!" },
        { title: "Homeless outreach", desc: "Help some homeless people." },
        { title: "Awareness drive", desc: "If you have a cause you think people need to be made aware of." }
      ]
    ]
  end

  # map of Milestone categories
  def self.req_cats
    [
      # the index is the category ID- ORDER IS IMPORTANT!
      { title: "Planning", desc: "Have things that still need to be figured out? Schedule some time to do it. Prior Planning Prevents Piss Poor Performance!" },
      { title: "Labor", desc: "Once you've figured out what needs doing, find volunteers to get it done." },
      { title: "Equipment", desc: "Make sure that any equipment you need is located ahead of time, so it's there when you need it." },
      { title: "Transportation", desc: "Find volunteers with vehicles who can help you get where you need to be!" }
    ]
  end

  # map of Milestone category index to subcategory array
  def self.req_subcats
    [
      [ # planning
        { title: "In-person", desc: "Trying to make plans as a group? In-person is always better." },
        { title: "Remote", desc: "Remote planning is great for when small decisions need to be made quickly!" }
      ],
      [ # labor
        { title: "Light labor", desc: "This should be well within the physical capabilities of an average person." },
        { title: "Heavy labor", desc: "If you need someone who can pick up and move around 50+ lbs" },
        { title: "Specialized labor", desc: "If you need a someone with a specialized skill, but it's okay if they're not a professional." },
        { title: "Professional labor", desc: "This task can only be handled by a professional. Keep in mind that you'll probably still need to pay them!" }
      ],
      [ # equipment
        { title: "Household items", desc: "Items common in households like trash bags, cleaning supplies, " },
        { title: "Food", desc: "Food, cooked or uncooked. If you'll need someone to cook, you may want to also specify a labor milestone!" },
        { title: "Lawn and garden", desc: "" },
        { title: "Hand tools", desc: "If you'll need hand tools that most people have. Hammers, screwdrivers, etc." },
        { title: "Specialized tools", desc: "Tools that not everyone has: a sewing machine, nail gun, soldering iron, etc." },
        { title: "Custom built/ordered", desc: "Are you going to need something custom-made? Define it here." },
        { title: "Heavy equipment", desc: "Examples: a stump grinder, jackhammer, backhoe, etc." }
      ],
      [ #Transportation
        { title: "Large Vehicle", desc: "Need large vehicle for transporting lots of people and/or equipment" },
        { title: "Medium Vehicle", desc: "Need medium vehicle for transporting a few people and/or equipment" },
        { title: "Small Vehicle", desc: "Need medium vehicle for transporting small amount of people and/or equipment" }
      ]
    ]
  end
end
