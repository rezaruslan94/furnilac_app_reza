class ReportsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

    def productivity_person
      @data_report_person = Pic.data_report_person(params[:start_date], params[:end_date], params[:area_combo])
      @area = Area.find(params[:area_combo]) if params[:area_combo].present?

      logger.debug
      respond_to do |format|
        format.html
        format.pdf do
          render  pdf: 'person',   # Excluding ".pdf" extension.
                  layout: 'pdf'
        end
      end
    end

  def productivity_people
    @pics = Pic.select('part_id, sum(wh) as total_wh, area_id').where(pic_date: (params[:start])..(params[:end])).group(:area_id)
    @parts = Part.where(id: @pics.collect(&:part_id))
    @areas = Area.where(id: @pics.collect(&:area_id))
    @employees = Employee.all
    @division = Division.all
    @data_report_people = Pic.data_report_people(params[:start_date], params[:end_date])
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: 'people',   # Excluding ".pdf" extension.
                layout: 'pdf'
      end
    end
  end

  def test
    @data_report_person_wh = Pic.data_report_person_wh(params[:start_date], params[:end_date], params[:area_combo])
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: 'person',   # Excluding ".pdf" extension.
                layout: 'pdf'
      end
    end
  end

  def report_params
  params.require(:pic).permit(:wh, :qty, :area_id, :part_id, :employee_id, :start_date, :end_date, :format)
end
end
