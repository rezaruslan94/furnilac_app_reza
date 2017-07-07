class TwhsController < ApplicationController
  before_action :set_twh, only: [:show, :edit, :update, :destroy]

  # GET /twhs
  # GET /twhs.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: TwhDatatable.new(view_context) }
    end
  end

  # GET /twhs/1
  # GET /twhs/1.json
  def show
  end

  # GET /twhs/new
  def new
    @twh = Twh.new
    @twh.pics.build
  end

  # GET /twhs/1/edit
  def edit
  end

  # POST /twhs
  # POST /twhs.json
  def create
    @twh = Twh.new(twh_params)

    respond_to do |format|
      if @twh.save
        format.html { redirect_to twhs_url, notice: 'Twh was successfully created.' }
        format.json { render :show, status: :created, location: @twh }
      else
        format.html { render :new }
        format.json { render json: @twh.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /twhs/1
  # PATCH/PUT /twhs/1.json
  def update
    respond_to do |format|
      if @twh.update(twh_params)
        format.html { redirect_to twhs_url, notice: 'Twh was successfully updated.' }
        format.json { render :show, status: :ok, location: @twh }
      else
        format.html { render :edit }
        format.json { render json: @twh.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twhs/1
  # DELETE /twhs/1.json
  def destroy
    @twh.destroy
    respond_to do |format|
      format.html { redirect_to twhs_url, notice: 'Twh was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_twh
      @twh = Twh.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def twh_params
      params.require(:twh).permit(:area_id, :pic_date, :wh,
      pics_attributes: [:id, :qty, :part_id, :twh_id, :_destroy])
    end
end
