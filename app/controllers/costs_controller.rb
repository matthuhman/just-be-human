class CostsController < ApplicationController

  def display
    costs = Cost.get_monthly_costs

    @cost_data = {}
    @monthly_cost = costs.last.mtd_cost
    month = costs.last.fetch_date.month
    costs.each do |c|
      if (c.fetch_date.month == month)
        @cost_data[c.fetch_date.strftime('%Y-%m-%d')] = c.daily_cost
      end
    end
  end


end