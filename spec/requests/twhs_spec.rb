require 'rails_helper'

RSpec.describe "Twhs", type: :request do
  describe "GET /twhs" do
    it "works! (now write some real specs)" do
      get twhs_path
      expect(response).to have_http_status(200)
    end
  end
end
