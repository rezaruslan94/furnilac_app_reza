class ItemDatatable < AjaxDatatablesRails::Base

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Item.name)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Item.name)
  end

  private
  def_delegators :@view, :link_to, :edit_item_path
  def data
    records.map do |record|
      {
        '0' => record.name,
        '1' => link_to('Edit', edit_item_path(record))
      }
    end
  end

  def get_raw_records
    # insert query here
    Item.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
