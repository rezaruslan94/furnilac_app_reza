class EmployeeDatatable < AjaxDatatablesRails::Base

include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Employee.name)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Employee.name)
  end

  private
    def_delegators :@view, :link_to, :edit_employee_path
  def data
    records.map do |record|
      {
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        '0' => record.name,
        '1' => link_to('Edit', edit_employee_path(record)),
        '2' => link_to('Delete', record, method: :delete, data: {confirm: 'Are you sure ?'})
      }
    end
  end

  def get_raw_records
    # insert query here
    Employee.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
