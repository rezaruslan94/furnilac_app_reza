require 'rails_helper'

RSpec.describe "twhs/new", type: :view do
  before(:each) do
    assign(:twh, Twh.new(
      :area_id => 1,
      :wh => 1
    ))
  end

  it "renders new twh form" do
    render

    assert_select "form[action=?][method=?]", twhs_path, "post" do

      assert_select "input#twh_area_id[name=?]", "twh[area_id]"

      assert_select "input#twh_wh[name=?]", "twh[wh]"
    end
  end
end
