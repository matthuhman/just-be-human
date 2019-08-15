class CostsController < ApplicationController

  def display
    costs = Cost.get_monthly_costs

    @cost_data = {}
    @monthly_cost = costs.last.mtd_cost
    costs.each do |c|
      @cost_data[c.fetch_date.strftime('%Y-%m-%d')] = c.daily_cost
    end

  end


end