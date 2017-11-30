require "rails_helper"

RSpec.describe NotasController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/notas").to route_to("notas#index")
    end

    it "routes to #new" do
      expect(:get => "/notas/new").to route_to("notas#new")
    end

    it "routes to #show" do
      expect(:get => "/notas/1").to route_to("notas#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/notas/1/edit").to route_to("notas#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/notas").to route_to("notas#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/notas/1").to route_to("notas#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/notas/1").to route_to("notas#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/notas/1").to route_to("notas#destroy", :id => "1")
    end

  end
end
