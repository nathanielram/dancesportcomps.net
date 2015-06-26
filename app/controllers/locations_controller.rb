class LocationsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  def search 
    search_results = [search_location, search_association].compact
    if search_results.present?
      search_results.each { |s| @competitions &= s }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)
    respond_to do |format|
      if @location.save
        flash[:success] = "Location was successfully created."
        format.html { redirect_to @location }
        format.json { render :show, status: :created, location: @location }
      else
        flash[:alert] = 'There was a problem creating the Location.'
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        flash[:success] = "Location was successfully updated."
        format.html { redirect_to @location }
        format.json { render :show, status: :ok, location: @location }
      else
        flash[:alert] = 'There was a problem updating the Location.'
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      flash[:success] = "Location was successfully destroyed."
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    def build_markers
      @markers = Gmaps4rails.build_markers(@occurences) do |occurence, marker|
        marker.lat occurence.location.latitude
        marker.lng occurence.location.longitude
        marker.infowindow occurence.competition.name
      end
    end    

    def search_location
      return if params[:location].blank? || params[:distance].blank?
      Location.near(params[:location], params[:distance].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name, :address, :city, :country, :latitude, :longitude)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
