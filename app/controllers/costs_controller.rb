class CostsController < ApplicationController

  def display
    @cost = Cost.get_costs
  end


end