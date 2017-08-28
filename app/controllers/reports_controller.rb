class ReportsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

    def productivity_person
      @data_report_person = Pic.data_report_person(params[:start_date], params[:end_date], params[:area_combo])
      @data_report_person_wh = Pic.data_report_person_wh(params[:start_date], params[:end_date], params[:area_combo])
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
    @data_report_people_area = Pic.data_report_people_area(params[:start_date], params[:end_date])
    @data_report_people_division = Pic.data_report_people_division(params[:start_date], params[:end_date])
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: 'people',   # Excluding ".pdf" extension.
                layout: 'pdf'
      end
    end
  end

  def test
    @data_report_people_area_test = Pic.data_report_people_area_test(params[:start_date], params[:end_date])
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: 'people',   # Excluding ".pdf" extension.
                layout: 'pdf'
      end
    end
  end

  def report_params
  params.require(:pic).permit(:wh, :qty, :area_id, :part_id, :employee_id, :start_date, :end_date, :format)
end
end
