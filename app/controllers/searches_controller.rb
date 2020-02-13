class SearchesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  authorize_resource class: false

  def show
    @t = params[:t]
    @q = params[:q]
    @results = Services::Search.new(@t, @q).search
  end
end
