class CompetitionsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_competition, only: [:show, :edit, :update, :destroy]

  #after_action :verify_authorized

  load_and_authorize_resource
  #skip_load_and_authorize_resource only: [:past, :future]
  #skip_authorization_check only: [:past, :future]

  # GET /competitions
  # GET /competitions.json
  def index
    # @competitions = Competition.all
    @occurences = Occurence.includes(:location, :competition).where("end_date >= ? AND start_date <= ?", Date.today, (Date.today + 1.year)).order(start_date: :asc) 
    #@occurences.competitions.order(start_date: :desc)
    #search
    build_markers
    #@search_path = search_competitions_path
    render :index
  end

  def past
    #@competitions = Competition.where("end_date < ?", Date.today).order(start_date: :desc) 
    #search
    #build_markers
    #@search_path = past_search_competitions_path
    #render :index
  end

  def future
    #@competitions = Competition.where("start_date > ?", (Date.today + 1.year)).order(start_date: :asc) 
    #search
    #build_markers
    #@search_path = future_search_competitions_path
    #render :index
  end

  def search 
    #search_results = [search_location, search_association].compact
    #if search_results.present?
    #  search_results.each { |s| @competitions &= s }
    #end
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
  end

  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions
  # POST /competitions.json
  def create
    @competition = Competition.new(competition_params)
    respond_to do |format|
      if @competition.save
        flash[:success] = "Competition was successfully created."
        format.html { redirect_to @competition }
        format.json { render :show, status: :created, location: @competition }
      else
        flash[:alert] = 'There was a problem creating the Competition.'
        format.html { render :new }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        flash[:success] = "Competition was successfully updated."
        format.html { redirect_to @competition }
        format.json { render :show, status: :ok, location: @competition }
      else
        flash[:alert] = 'There was a problem updating the Competition.'
        format.html { render :edit }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    @competition.destroy
    respond_to do |format|
      flash[:success] = "Competition was successfully destroyed."
      format.html { redirect_to competitions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    def build_markers
      @markers = Gmaps4rails.build_markers(@occurences) do |occurence, marker|
        marker.lat occurence.location.latitude
        marker.lng occurence.location.longitude
        marker.infowindow render_to_string(:partial => "competitions/infowindow", :locals => { :object => occurence})
      end
    end    

    def search_location
      return if params[:location].blank? || params[:distance].blank?
      Competition.near(params[:location], params[:distance].to_i)
    end

    def search_association
      return if params[:comp_association].blank?
      Competition.join(:occurences).where("comp_association = ?", params[:comp_association]).order("occurences.start_date asc") 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      #params.require(:competition).permit(:name, :comp_association, :start_date, :end_date, :num_days, :location_name, :address, :city, :country, :website, :latitude, :longitude, :distance)
      #locations_attributes: [:id, :name, :address, :city, :country, :latitude, :longitude, :_destroy],
      params.require(:competition).permit(:name, :comp_association, :website, :country#,
        #locations_attributes: [:id, :name, :address, :city, :country, :latitude, :longitude, :_destroy]
      )
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
