class Cost < ApplicationRecord


  def self.get_costs
    most_recent_cost = Cost.last

    if most_recent_cost && most_recent_cost.fetch_date == Date.today
      return most_recent_cost
    else
      
      ce = Aws::CostExplorer::Client.new

      resp = ce.get_cost_and_usage({
        time_period: {
          start: Date.today.strftime("%Y-%m-01"),
          end: Date.today.at_beginning_of_month.next_month.strftime("%Y-%m-01")
        },
        granularity: "MONTHLY",
        metrics: ["AmortizedCost"]
      })
      




      @new_cost = Cost.new

      binding.pry

      monthly_cost = resp.results_by_time.first.total["AmortizedCost"].amount.to_f

      @new_cost.mtd_cost = monthly_cost.round(2)

      if most_recent_cost
        daily_cost = most_recent_cost.mtd_cost - monthly_cost
      else
        daily_cost = monthly_cost
      end

      @new_cost.daily_cost = daily_cost

      

      if @new_cost.save
        return @new_cost
      else
        puts 'COST DID NOT SAVE SUCCESSFULLY, RETURNING LAST GOOD COST OBJECT'
        return most_recent_cost
      end

      
    end

    return nil

  end
end
