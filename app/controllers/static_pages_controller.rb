class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!, except: [:admin]
  before_action :admin_user, only: [:admin]
  
  def about
  end
  
  def contact
  end
  
  def admin
  end
  
  def home
    @galleries = Gallery.last(5).reverse
    @pictures = Picture.default
  end
  
  private
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
