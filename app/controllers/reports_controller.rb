class ReportsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

    def productivity_person
      @data_report_person = Pic.data_report_person(params[:start_date], params[:end_date], params[:area_combo])
      @data_report_person_wh = Pic.data_report_person_wh(params[:start_date], params[:end_date], params[:area_combo])
      @area = Area.find(params[:area_combo]) if params[:area_combo].present?
      @combo_area = Area.order(:name)

      logger.debug
      respond_to do |format|
        format.html
        format.pdf do
          render  pdf: 'person',   # Excluding ".pdf" extension.
                  layout: 'pdf',
                   page_size: 'A4',            # default A4
                   margin:  {
                     top:               13,                     # default 10 (mm)
                     bottom:            30,
                     left:              10,
                     right:             10 }
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
                layout: 'pdf',
                 page_size: 'A4',            # default A4
                 margin:  {
                   top:               12,                     # default 10 (mm)
                   bottom:            30,
                   left:              10,
                   right:             10 }
      end
    end
  end

  def test
    @data_report_people_area_test = Pic.data_report_people_area_test(params[:start_date], params[:end_date])
    @data_report_people_division_test = Pic.data_report_people_division_test(params[:start_date], params[:end_date])
    respond_to do |format|
        format.html
        format.pdf do
          pdf = Prawn::Document.new
          pdf.text 'LAPORAN PRODUKTIVITAS PRODUKSI PERSON'
          pdf.table([["Periode",":",params[:start_date],"s/d",params[:end_date]]])
          pdf.move_down 20
          pdf.table([["Area/PIC", "EH", "WH", "P"]], :column_widths => [100, 100, 100, 100])
          @data_report_people_area_test.each do |pic|
            pdf.table([[pic.area, pic.eh.round(2), pic.wh, pic.nilai_p.round(0)]], :column_widths => [100, 100, 100, 100])
          end

          pdf.move_down 20
          pdf.text 'Division'
          pdf.table([["DIVISION", "PIC", "EH", "WH", "P"]], :column_widths => [100, 100, 100, 100, 50])
          @data_report_people_division_test.each do |pic|
            pdf.table([[pic.division_name, pic.pic, pic.eh.round(2), pic.wh, pic.nilai_p.round(0)]], :column_widths => [100, 100, 100, 100, 50])
          end

          send_data pdf.render,
            type: "application/pdf",
            disposition: "inline"

        end
      end
  end




  def report_params
  params.require(:pic).permit(:wh, :qty, :area_id, :part_id, :employee_id, :start_date, :end_date, :format)
end
end
