class CoursesController < ApplicationController
  def index
    @search_term = params[:looking_for] || 'learn'
    @courses = Coursera.for(@search_term)
  end
end
