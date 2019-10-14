class RemovePostablePolymorphism < ActiveRecord::Migration[6.0]
  def change

    add_column :posts, :opportunity_id, :uuid

    Post.all.each do |p|
      if p.postable_type == "Opportunity"
        p.opportunity_id = p.postable_id
        p.save
      end
    end

    remove_column :posts, :postable_id
    remove_column :posts, :postable_type





  end
end
