class NewslettersController < ApplicationController
  before_action :admin_user, except: [:show, :index]
  before_action :logged_in_user
  
  def new
    @newsletter = Newsletter.new
  end
  
  def show
    @newsletter = Newsletter.find(params[:id])
    if current_user.admin == false
      redirect_to(newsletters_url) unless @newsletter.published? && @newsletter.emailed?
    end
  end
  
  def index
    @published_newsletters = Newsletter.published.emailed
    @unemailed_newsletters = Newsletter.published.unemailed
    @unpublished_newsletters = Newsletter.unpublished
  end
  
  def create
    @newsletter = Newsletter.new(newsletter_params)

    respond_to do |format|
      if @newsletter.save
        if @newsletter.published == true
          User.subscriber.each do |user|
            EmailWorker.perform_async(user.id, @newsletter.id)
          end        
        end
        format.html { redirect_to @newsletter, notice: 'Newsletter was successfully created.' }
        format.json { render :show, status: :created, location: @newsletter}
      else
        format.html { render :new }
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @newsletter = Newsletter.find(params[:id])
  end
  
  def update
    @newsletter = Newsletter.find(params[:id])
    if @newsletter.update_attributes(newsletter_params)
      flash[:success] = "Newsletter updated"
      redirect_to @newsletter
    else
      render 'edit'
    end
  end
  
  def destroy
    Newsletter.find(params[:id]).destroy
    flash[:success] = "Newsletter was deleted"
    redirect_to newsletters_url
  end
  
  private
  
    def newsletter_params
        params.require(:newsletter).permit(:title, :content, :published, :emailed)
    end
    
    def logged_in_user
      unless user_signed_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
