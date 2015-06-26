class OccurencesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_occurence, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  def index
    @occurences = Occurence.all
    #@occurences = Occurence.where("end_date >= ? AND start_date <= ?", Date.today, (Date.today + 1.year)).order(start_date: :asc) 
    render :index
  end

  # GET /occurences/1
  # GET /occurences/1.json
  def show
  end

  # GET /occurences/new
  def new
    @occurence = Occurence.new
  end

  # GET /occurences/1/edit
  def edit
  end

  # POST /occurences
  # POST /occurences.json
  def create
    @occurence = Occurence.new(occurence_params)
    respond_to do |format|
      if @occurence.save
        flash[:success] = "Occurence was successfully created."
        format.html { redirect_to @occurence }
        format.json { render :show, status: :created, location: @occurence }
      else
        flash[:alert] = 'There was a problem creating the Occurence.'
        format.html { render :new }
        format.json { render json: @occurence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /occurence/1
  # PATCH/PUT /occurence/1.json
  def update
    respond_to do |format|
      if @occurence.update(occurence_params)
        flash[:success] = "Occurence was successfully updated."
        format.html { redirect_to @occurence }
        format.json { render :show, status: :ok, location: @occurence }
      else
        flash[:alert] = 'There was a problem updating the Occurence.'
        format.html { render :edit }
        format.json { render json: @occurence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occurence/1
  # DELETE /occurence/1.json
  def destroy
    @occurence.destroy
    respond_to do |format|
      flash[:success] = "Occurence was successfully destroyed."
      format.html { redirect_to occurences_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occurence
      @occurence = Occurence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def occurence_params
      params.require(:occurence).permit(:start_date, :end_date, :num_days, :location_id, :competition_id)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
