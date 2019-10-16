class MarkAllOpposDefined < ActiveRecord::Migration[6.0]
  def change

    Requirement.all.each do |r|
      if !r.defined
        puts "Changing abstract requirement #{r.title} to defined."
        r.defined = true
        r.save
      end
    end


    Opportunity.all.each do |o|
      if !o.defined
        puts "Changing abstract opportunity #{o.title} to defined."
        o.defined = true
        o.save
      end
    end

  end
end
