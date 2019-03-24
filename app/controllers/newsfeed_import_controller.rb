class NewsfeedImportController < NewsfeedBaseController
  skip_filter :require_login, only: [:show]
  skip_before_filter :require_moder_rights, only: [:show]

  def update
    @import_post = NewsfeedImport.find(params[:id])
    if params[:newsfeed_import]
      @import_post.title = newsfeed_local_params[:title]
      @import_post.link = newsfeed_local_params[:link]
      @import_post.date_created = newsfeed_local_params[:date_created]
      @import_post.is_ignoring = newsfeed_local_params[:is_ignoring]
      if @import_post.save!
        redirect_to newsfeed_edit_import_index_path
      end
    end
  end

private

  def newsfeed_local_params
    return params.require(:newsfeed_import).permit(:title, :initial_title, :tags, :link, :date_created, :is_ignoring)
  end
end