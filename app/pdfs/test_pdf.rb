require 'prawn'
class TestPdf < Prawn::Document
  def initialize(pics)
    super()
    @pic = Pic.order("id DESC").all
    table report_test
  end
  def report_test
    [
      [Ini_Qty = @pic.qty]
    ]
  end
end
