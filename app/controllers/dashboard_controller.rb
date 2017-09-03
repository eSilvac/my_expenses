class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @tab = :dashboard
  end
end
