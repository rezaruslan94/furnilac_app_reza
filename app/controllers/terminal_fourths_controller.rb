class TerminalFourthsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_buyer, only: [:bulk_new, :bulk_insert]
  before_action :set_terminal_fourth, only: [:show, :edit, :update, :destroy, :edit_finish, :update_finish]

  def bulk_new
    @buyer = Buyer.find params[:buyer_id]
        @buyer.terminal_fourths.build
  end

  def bulk_insert
    respond_to do |format|
      if @buyer.update(insert_terminal_params)
        format.html { redirect_to terminal_fourths_url, notice: 'Buyer was successfully updated.' }
        format.json { render :show, status: :ok, location: @buyer }
      else
        format.html { render :bulk_new }
        format.json { render json: @buyer.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_finish
  end

  def update_finish
    respond_to do |format|
      if @terminal_fourth.update(update_finish_params)
        format.html { redirect_to @terminal_fourth, notice: 'Terminal fourth was successfully updated.' }
        format.json { render :show, status: :ok, location: @terminal_fourth }
      else
        format.html { render :edit_finish }
        format.json { render json: @terminal_fourth.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /terminal_fourths
  # GET /terminal_fourths.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: TerminalFourthDatatable.new(view_context) }
    end
  end

  # GET /terminal_fourths/1
  # GET /terminal_fourths/1.json
  def show
  end

  # GET /terminal_fourths/new
  def new
    @terminal_fourth = TerminalFourth.new
  end

  # GET /terminal_fourths/1/edit
  def edit
  end

  # POST /terminal_fourths
  # POST /terminal_fourths.json
  def create
    @terminal_fourth = TerminalFourth.new(terminal_fourth_params)

    respond_to do |format|
      if @terminal_fourth.save
        format.html { redirect_to @terminal_fourth, notice: 'Terminal fourth was successfully created.' }
        format.json { render :show, status: :created, location: @terminal_fourth }
      else
        format.html { render :new }
        format.json { render json: @terminal_fourth.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /terminal_fourths/1
  # PATCH/PUT /terminal_fourths/1.json
  def update
    respond_to do |format|
      if @terminal_fourth.update(terminal_fourth_params)
        format.html { redirect_to @terminal_fourth, notice: 'Terminal fourth was successfully updated.' }
        format.json { render :show, status: :ok, location: @terminal_fourth }
      else
        format.html { render :edit }
        format.json { render json: @terminal_fourth.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terminal_fourths/1
  # DELETE /terminal_fourths/1.json
  def destroy
    @terminal_fourth.destroy
    respond_to do |format|
      format.html { redirect_to terminal_fourths_url, notice: 'Terminal fourth was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terminal_fourth
      @terminal_fourth = TerminalFourth.find(params[:id])
    end

    def set_buyer
      @buyer = Buyer.find(params[:buyer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def terminal_fourth_params
      params.require(:terminal_fourth).permit(:po, :qty, :finish, :terminal_inspect, :terminal_stuffing, :buyer_id, :item_name, :product_finish)
    end

    def insert_terminal_params
      params.require(:buyer).permit(
      terminal_fourths_attributes: [:po, :qty, :finish, :terminal_inspect, :terminal_stuffing, :buyer_id, :item_name, :_destroy]
      )
    end

    def update_finish_params
      params.require(:terminal_fourth).permit(:product_finish)
    end
end
