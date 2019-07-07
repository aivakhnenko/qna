class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    if current_user.author_of?(@link.linkable)
      @link.destroy
    else
      redirect_to @link.linkable, error: 'Only author can delete this link'
    end
  end
end
