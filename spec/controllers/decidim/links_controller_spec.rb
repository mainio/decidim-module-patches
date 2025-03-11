# frozen_string_literal: true

require "spec_helper"

describe Decidim::LinksController, type: :controller do
  routes { Decidim::Core::Engine.routes }

  let(:organization) { create :organization }

  before do
    request.env["decidim.current_organization"] = organization
  end

  describe "#new" do
    it "adds the correct headers" do
      get :new, params: { external_url: "https://www.mainiotech.fi" }

      expect(response.headers["X-Robots-Tag"]).to eq("none")
      expect(response.headers["Link"]).to eq(%(<http://test.host/link>; rel="canonical"))
    end
  end
end
