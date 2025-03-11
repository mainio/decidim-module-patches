# frozen_string_literal: true

require "spec_helper"

describe "Explore results", versioning: true, type: :system do
  include_context "with a component"

  let(:manifest_name) { "accountability" }
  let(:results_count) { 5 }
  let!(:scope) { create :scope, organization: organization }
  let!(:results) do
    create_list(
      :result,
      results_count,
      component: component
    )
  end

  before do
    component.update(settings: { scopes_enabled: true })

    visit path
  end

  describe "show" do
    let(:path) { decidim_participatory_process_accountability.result_path(id: result.id, participatory_process_slug: participatory_process.slug, component_id: component.id) }
    let(:results_count) { 1 }
    let(:result) { results.first }

    context "with timeline entries" do
      let!(:timeline_entry) { create(:timeline_entry, description: description, result: result) }
      let(:description) do
        generate_localized_title(:timeline_entry_description).transform_values { |v| "<p>#{v}</p>" }
      end

      before do
        # Revisit the path to load updated results
        visit path

        expect(page).to have_text("PROJECT EVOLUTION")
        page.scroll_to(find(".section-heading", text: "PROJECT EVOLUTION"))
      end

      it "displays the timeline entry description correctly" do
        expect(page).not_to have_content("&lt;p&gt")
      end
    end
  end
end
