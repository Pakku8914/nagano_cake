class Admin::HomesController < ApplicationController
  layout "admin_app"

  def top
    @orders = Order.all
  end

end
