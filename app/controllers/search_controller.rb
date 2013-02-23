class SearchController < ApplicationController

  def index
    @result = Search.do params[:term]
    respond_to do |format|
      format.html 
      format.json 
    end
  end
  
end
