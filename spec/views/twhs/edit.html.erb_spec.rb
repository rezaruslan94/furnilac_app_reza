require 'rails_helper'

RSpec.describe "twhs/edit", type: :view do
  before(:each) do
    @twh = assign(:twh, Twh.create!(
      :area_id => 1,
      :wh => 1
    ))
  end

  it "renders the edit twh form" do
    render

    assert_select "form[action=?][method=?]", twh_path(@twh), "post" do

      assert_select "input#twh_area_id[name=?]", "twh[area_id]"

      assert_select "input#twh_wh[name=?]", "twh[wh]"
    end
  end
end
