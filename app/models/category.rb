require 'yaml'

class Category

  #
  # get all category titles
  def self.opportunity_titles
    opportunity_cats.map { |c| c[:title] }
  end

  #
  # get all category titles with descriptions
  def self.opportunity_titles_with_desc
    opportunity_cats
  end

  def self.opportunity_title_by_id(id)
    title = opportunity_cats[id][:title]
    title
  end
  # #
  # # get all subcategory titles for a given category id
  # def self.opportunity_subcat_titles(cat_id)
  #   self.opportunity_subcats[cat_id].map { |sc| sc[:title] }
  # end

  # #
  # # get all subcat titles and descriptions for a given category id
  # def self.opportunity_subcat_titles_with_desc(cat_id)
  #   return self.opportunity_subcats[cat_id]
  # end

  def self.req_titles
    req_cats.map { |c| c[:title] }
  end

  #
  # get all category titles with descriptions
  def self.req_titles_with_desc
    req_cats
  end

  #
  # get all subcategory titles for a given category id
  def self.req_subcat_titles(cat_id)
    req_subcats[cat_id].map { |sc| sc[:title] }
  end

  #
  # get all subcat titles and descriptions for a given category id
  def self.req_subcat_titles_with_desc(cat_id)
    req_subcats[cat_id]
  end

  def self.get_all_opportunity_subcats
    opportunity_subcats
  end

  ## TODO: make these constants so that we're not recreating them every time you reference Category

  # map of integer ID's to categories
  private
  def self.opportunity_cats
    [
      # the index is the category ID- ORDER IS IMPORTANT!
      { title: "Outreach", desc: "Spread the word about something important to you." },
      { title: "Cleanup", desc: "Clean up in your community- examples include trash pickups, park cleanups, beautification projects, etc." },
      { title: "Fundraising", desc: "Organize people to help fundraise for an individual, cause, or organization." },
      { title: "Goods", desc: "Organize a food/clothing/goods collection in your community." },
      { title: "Caregiving", desc: "Organize help for specific individuals or groups in your neighborhood who need it." }
    ]
  end

  # # map of Opportunity category index to subcategory arrays
  # # commented out on 20190910 by @matthuhman - gonna leave this around for now, just in case
  # private self.opportunity_subcats
  # [
  #   [ # community cleanup
  #     { title: "Trash pickup", desc: "Pick up some trash, damnit!" },
  #     { title: "Property maintenance", desc: "There's a property in my neighborhood that needs to be cleaned up!" }
  #     ],
  #   [ # labor
  #     { title: "For a person", desc: "For a person in need." },
  #     { title: "For a cause", desc: "For a cause that you care about."},
  #     { title: "For an organization", desc: "For an organization that needs the help!" }
  #     ],
  #   [ # equipment
  #     { title: "Food drive", desc: "Collect food for a cause!" },
  #     { title: "Homeless outreach", desc: "Help some homeless people." },
  #     { title: "Awareness drive", desc: "If you have a cause you think people need to be made aware of." }
  #     ]
  # ]
  # end

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
