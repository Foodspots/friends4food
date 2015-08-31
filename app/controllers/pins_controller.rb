class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :correct_user, only: [:destroy]

  def index
    @pins = Pin.search(params[:search])
    friends_favorite_restaurants = current_user.friends_favorite_restaurants
  
    if friends_favorite_restaurants.present?
      @pins = (friends_favorite_restaurants & @pins) | (@pins - friends_favorite_restaurants)    
    end

    @pins = Kaminari.paginate_array(@pins).page(params[:page]).per(RECORDS_PER_PAGE)
    
  end

  def sorted_by_distance
    if @latitude.present? && @longitude.present?
      @pins = Pin.search(params[:search]).near([@latitude, @longitude], 10000)
      @pins = @pins.page(params[:page]).per(RECORDS_PER_PAGE)
      render locals: {current_user: current_user}
    else
      index
    end
  end

  def import
    Pin.import(params[:file])
    redirect_to root_url, notice: "Restaurants imported."
  end

  def my_pins
    @pins = current_user.pins
  end

  def my_favorites
    @pins = Kaminari.paginate_array(current_user.find_liked_items).page(params[:page]).per(RECORDS_PER_PAGE)
  end

  def like
    @pin.liked_by current_user
    redirect_to :back, notice: 'You have added this restaurant to your favorite list.'
  end

  def unlike
    @pin.unliked_by current_user
    redirect_to :back, notice: 'You have removed this restaurant from your favorite list.'
  end

  def show
	  render locals: {current_user: current_user}
  end

  def new
    @pin = current_user.pins.build
  end

  def edit
  end

  def create
    @pin = current_user.pins.build(pin_params)
    if @pin.save
      ModelMailer.new_pin_notification(@pin).deliver
      redirect_to @pin, notice: 'You have added this restaurant.'
    else
      render action: 'new'
    end
  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: 'You have changed the restaurant.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @pin.destroy
    redirect_to pins_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def correct_user
      @pin = current_user.pins.find_by(id: params[:id])
      redirect_to pins_path, notice: "It is only allowed to change the restaurants you have added my yourself." if @pin.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pin_params
      params.require(:pin).permit(:description, :image, :name, :address, :place, :postal_code, :telephone_number, :website, :emailadress, :location, :latitude, :longitude, :search, :emailadress, :openinghours, :price, :category, :neighbourhood, :kitchen)
    end
end