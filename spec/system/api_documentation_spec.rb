# frozen_string_literal: true

require "spec_helper"

describe "Documentation" do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  describe "documentation" do
    before do
      # Should be the default but can be affected by ENV vars
      allow(Decidim::Api).to receive(:disclose_system_version).and_return(false)
    end

    it "does not disclose system version by default" do
      visit decidim_api.documentation_path
      expect(page).to have_no_css(".content .version")
      expect(page).to have_no_content("Decidim #{Decidim.version}")
    end
  end
end
