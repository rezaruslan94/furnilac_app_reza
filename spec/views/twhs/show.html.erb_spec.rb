require 'rails_helper'

RSpec.describe "twhs/show", type: :view do
  before(:each) do
    @twh = assign(:twh, Twh.create!(
      :area_id => 2,
      :wh => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
