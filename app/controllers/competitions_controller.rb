class CompetitionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :past, :future]
  before_action :set_competition, only: [:show, :edit, :update, :destroy]

  # GET /competitions
  # GET /competitions.json
  def index
    # @competitions = Competition.all
    results = Competition.where(["end_date >= ? AND start_date <= ?", Date.today, (Date.today + 1.year)]).order("start_date asc")
    if search
      @competitions &= results
    else
      @competitions = results
    end
    build_markers
    render :index
  end

  def past
    @competitions = Competition.where(["end_date < ?", Date.today]).order("start_date desc")
    build_markers
    render :index
  end

  def future
    @competitions = Competition.where(["start_date > ?", (Date.today + 1.year)]).order("start_date asc")
    build_markers
    render :index
  end

  def search 
    unless params[:location].empty? || params[:distance].empty?
      @competitions = Competition.near(params[:location], params[:distance].to_i)
    end
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
        format.html { redirect_to @competition, notice: 'Competition was successfully created.' }
        format.json { render :show, status: :created, location: @competition }
      else
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
        format.html { redirect_to @competition, notice: 'Competition was successfully updated.' }
        format.json { render :show, status: :ok, location: @competition }
      else
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
      format.html { redirect_to competitions_url, notice: 'Competition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    def build_markers
      @markers = Gmaps4rails.build_markers(@competitions) do |comp, marker|
        marker.lat comp.latitude
        marker.lng comp.longitude
        marker.infowindow comp.name
      end
    end    

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:competition).permit(:name, :comp_association, :start_date, :end_date, :location_name, :location, :address, :city, :country, :website, :latitude, :longitude, :distance)
    end
end
