require "rails_helper"

RSpec.describe TwhsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/twhs").to route_to("twhs#index")
    end

    it "routes to #new" do
      expect(:get => "/twhs/new").to route_to("twhs#new")
    end

    it "routes to #show" do
      expect(:get => "/twhs/1").to route_to("twhs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/twhs/1/edit").to route_to("twhs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/twhs").to route_to("twhs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/twhs/1").to route_to("twhs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/twhs/1").to route_to("twhs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/twhs/1").to route_to("twhs#destroy", :id => "1")
    end

  end
end
