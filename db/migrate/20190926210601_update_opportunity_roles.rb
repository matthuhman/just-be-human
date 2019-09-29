class UpdateOpportunityRoles < ActiveRecord::Migration[6.0]
  def change

    OpportunityRole.all.each do |r|
      if r.is_coming.nil? || r.has_responded.nil? || r.additional_vols.nil?
        r.is_coming = false
        r.has_responded = false
        r.additional_vols = 0
      end


      if r.level == 4
        r.level = 5
      end

      if r.level == 3
        r.title = "Volunteer+"
      end

      r.save
    end
  end
end
