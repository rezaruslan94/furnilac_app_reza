require 'rails_helper'

RSpec.describe "twhs/index", type: :view do
  before(:each) do
    assign(:twhs, [
      Twh.create!(
        :area_id => 2,
        :wh => 3
      ),
      Twh.create!(
        :area_id => 2,
        :wh => 3
      )
    ])
  end

  it "renders a list of twhs" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
