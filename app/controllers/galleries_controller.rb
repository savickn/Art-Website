class GalleriesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:show, :index]
  before_action :admin_user, except: [:show, :index]
  
  def purchase
  end
  
  def mark_as_sold
  end
  
  def new
    @gallery = Gallery.new
  end
  
  def show
    @gallery  = Gallery.find(params[:id])
    @pictures = @gallery.pictures
  end
  
  def index
    @galleries = Gallery.all
    @pictures = Picture.default
  end
  
  def create
    @gallery = Gallery.new(gallery_params)

    respond_to do |format|
      if @gallery.save
        if params[:images]
          params[:images].each do |image|
            @gallery.pictures.create(image: image)
          end
        end
        
        format.html { redirect_to @gallery, notice: 'Gallery was successfully created.' }
        format.json { render :show, status: :created, location: @gallery}
      else
        format.html { render :new }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @gallery = Gallery.find(params[:id])
  end
  
  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(gallery_params)
      if params[:images]
         params[:images].each do |image|
            @gallery.pictures.create(image: image)
         end
      end
      # Handle a successful update.
      flash[:success] = "Gallery updated"
      redirect_to @gallery
    else
      render 'edit'
    end
  end
  
  def destroy
    Gallery.find(params[:id]).destroy
    flash[:success] = "Gallery was deleted"
    redirect_to galleries_url
  end
  
  private
  
    def gallery_params
        params.require(:gallery).permit(:title, :description, :price, :pictures)
    end
  
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
