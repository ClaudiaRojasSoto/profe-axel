class HomeController < ApplicationController
  def show
    @page = HomePage.new
  end
end
