class PicturesController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  
  def new
    @gallery = Gallery.find(params[:gallery_id])
    @picture = @gallery.pictures.build
  end
  
  def show
    @picture = Picture.find(params[:id])
  end
  
  def index
    @pictures = Picture.all
  end
  
  def create
    @picture = Picture.new(picture_params)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully added to the gallery.' }
        format.json { render :show, status: :created, location: @picture}
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @picture = Picture.find(params[:id])
  end
  
  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(picture_params)
      # Handle a successful update.
      flash[:success] = "Picture updated"
      redirect_to pictures_url
    else
      render 'edit'
    end
  end
  
  def destroy
    Picture.find(params[:id]).destroy
    flash[:success] = "Picture was removed from the gallery"
    redirect_to :back
  end
  
  private
  
    def picture_params
        params.require(:picture).permit(:image, :gallery_id, :default_image)
    end
  
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
