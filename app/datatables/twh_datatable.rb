class TwhDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Area.name Twh.pic_date Twh.wh)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Area.name Twh.pic_date Twh.wh)
  end

  private
  def_delegators :@view, :link_to, :edit_twh_path, :bulk_new_twh_pics_path
  def data
    records.map do |record|
      {
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        '0' => record.area.name,
        '1' => record.pic_date,
        '2' => record.wh,
        '3' => link_to('Insert', bulk_new_twh_pics_path(record)),
        '4' => link_to('Edit', edit_twh_path(record))
      }
    end
  end

  def get_raw_records
    # insert query here
    Twh.eager_load(:area).distinct
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
