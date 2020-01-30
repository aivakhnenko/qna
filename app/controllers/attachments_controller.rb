class AttachmentsController < ApplicationController
  skip_authorization_check

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment.record
    if current_user.author_of?(@record)
      @attachment.purge
    else
      redirect_to @record, error: 'Only author can delete this file'
    end
  end
end
