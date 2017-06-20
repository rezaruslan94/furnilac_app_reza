class PicsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_area, only: [:bulk_new, :bulk_insert]
  before_action :set_pic, only: [:show, :edit, :update, :destroy]

  # GET /pics
  # GET /pics.json

  def bulk_new
    @area = Area.find params[:area_id]
        @area.pics.build(pic_date: Date.today)
      logger.debug "isi area.pics: " + @area.pics.inspect
  end

  ###############
    def bulk_insert
      respond_to do |format|
        if @area.update(pic_params)
          format.html { redirect_to pics_url, notice: 'Area was successfully save.' }
          format.json { render :show, status: :ok, location: @area }
        else
          format.html { render :bulk_new }
          format.json { render json: @area.errors, status: :unprocessable_entity }
        end
      end
    end
  ##############

  def index
    respond_to do |format|
      format.html
      format.json { render json: PicDatatable.new(view_context) }
    end
  end

  # GET /pics/1
  # GET /pics/1.json
  def show
  end

  # GET /pics/new
  def new
    @pic = Pic.new
  end

  # GET /pics/1/edit
  def edit
  end

  # POST /pics
  # POST /pics.json
  def create
    @pic = Pic.new(pic_params)

    respond_to do |format|
      if @pic.save
        format.html { redirect_to @pic, notice: 'Pic was successfully created.' }
        format.json { render :show, status: :created, location: @pic }
      else
        format.html { render :new }
        format.json { render json: @pic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pics/1
  # PATCH/PUT /pics/1.json
  def update
    respond_to do |format|
      if @pic.update(part_update_params)
        format.html { redirect_to @pic, notice: 'Pic was successfully updated.' }
        format.json { render :show, status: :ok, location: @pic }
      else
        format.html { render :edit }
        format.json { render json: @pic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pics/1
  # DELETE /pics/1.json
  def destroy
    @pic.destroy
    respond_to do |format|
      format.html { redirect_to pics_url, notice: 'Pic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pic
      @pic = Pic.find(params[:id])
    end

    def set_area
      @area = Area.find(params[:area_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_update_params
      params.require(:pic).permit(:wh, :qty, :part_id, :area_id, :pic_date)
    end

    def pic_params
      params.require(:area).permit(
      pics_attributes: [:wh, :qty, :part_id, :area_id, :pic_date, :_destroy])
    end
end
