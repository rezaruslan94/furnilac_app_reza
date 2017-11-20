class PartDatatable < AjaxDatatablesRails::Base

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Part.number)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Part.number)
  end

  private
    def_delegators :@view, :link_to, :edit_part_path

  def data
    records.map do |record|
      {
        '0' => record.number,
        '1' => link_to('Edit', edit_part_path(record)),
        '2' => link_to('Delete', record, method: :delete, data: {confirm: 'Are you sure?'})
      }
    end
  end

  def get_raw_records
    # insert query here
    Part.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
