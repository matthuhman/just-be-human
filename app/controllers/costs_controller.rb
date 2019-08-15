class CostsController < ApplicationController

  def display
    @costs = Cost.get_monthly_costs
  end


end