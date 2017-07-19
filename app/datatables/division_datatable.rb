class DivisionDatatable < AjaxDatatablesRails::Base

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Department.name Division.name Employee.name)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Department.name Division.name Employee.name)
  end

  private
    def_delegators :@view, :link_to, :edit_division_path
  def data
    records.map do |record|
      {
        '0' => record.department.name,
        '1' => record.name,
        '2' => record.employee.name,
        '3' => link_to('Edit', edit_division_path(record))
      }
    end
  end

  def get_raw_records
    # insert query here
    Division.eager_load(:department, :employee).distinct
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
