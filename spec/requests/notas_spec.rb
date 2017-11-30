require 'rails_helper'

RSpec.describe "Notas", type: :request do
  describe "GET /notas" do
    it "works! (now write some real specs)" do
      get notas_path
      expect(response).to have_http_status(200)
    end
  end
end
