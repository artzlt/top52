class NewsfeedLocalController < ApplicationController
  before_filter :require_login, except: [:show]
  before_filter :authorize_admins!, except: [:show]

  def index
    @local_post = NewsfeedLocal.new
  end

  def create
    @local_post = NewsfeedLocal.new(newsfeed_local_params)
    if @local_post.save
      redirect_to newsfeed_edit_local_index_path
    else
      redirect_to newsfeed_local_index_path
    end
  end

  def update
    @local_post = NewsfeedLocal.find(params[:id])
    if params[:newsfeed_local]
      @local_post.title = newsfeed_local_params[:title]
      @local_post.announce = newsfeed_local_params[:announce]
      @local_post.body = newsfeed_local_params[:body]
      @local_post.link = newsfeed_local_params[:link]
      @local_post.date_created = newsfeed_local_params[:date_created]
      @local_post.start_date = newsfeed_local_params[:start_date]
      @local_post.end_date = newsfeed_local_params[:end_date]
      @local_post.header_weight = newsfeed_local_params[:header_weight]
      @local_post.footer_weight = newsfeed_local_params[:footer_weight]
      if @local_post.save!
        redirect_to newsfeed_edit_local_index_path
      end
    end
  end

  def show
    @local_post = NewsfeedLocal.find(params[:id])
  end

  def destroy
    @local_post = NewsfeedLocal.find(params[:id])
    @local_post.delete
    redirect_to newsfeed_edit_local_index_path
  end

  private
  def authorize_admins!
    authorize! :access, :admin
  end

  def newsfeed_local_params
    return params.require(:newsfeed_local).permit(:title, :announce, :link, :body, :date_created, :start_date, :end_date, :header_weight, :footer_weight)
  end
end