# frozen_string_literal: true

require "spec_helper"

describe "Admin manages organization", type: :system do
  include ActionView::Helpers::SanitizeHelper

  let(:organization) { create(:organization) }
  let(:attributes) { attributes_for(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  describe "edit" do
    context "when using the rich text editor" do
      before do
        visit decidim_admin.edit_organization_path

        # Makes sure in the error screenshots the editor is visible
        page.scroll_to(find("#organization-admin_terms_of_use_body-tabs-admin_terms_of_use_body-panel-0 .editor"))
      end

      context "when the admin terms of use content has only a video" do
        let(:organization) { create(:organization, admin_terms_of_use_body: {}) }

        before do
          within ".editor" do
            within ".editor .ql-toolbar" do
              find("button.ql-video").click
            end
            within "div[data-mode='video'].ql-tooltip.ql-editing" do
              find("input[data-video='Embed URL']").fill_in with: "https://www.youtube.com/watch?v=f6JMgJAQ2tc"
              find("a.ql-action").click
            end
          end
        end

        it "saves the content correctly with the video" do
          click_button "Update"
          expect(page).to have_content("Organization updated successfully")

          organization.reload
          expect(translated(organization.admin_terms_of_use_body)).to eq(
            %(<iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/f6JMgJAQ2tc?showinfo=0"></iframe>)
          )
        end

        it "does not remove the video" do
          click_button "Update"
          expect(page).to have_content("Organization updated successfully")

          # Close the callout for the new update to initiate the callout again
          within ".callout-wrapper .callout.success" do
            click_button "×"
          end

          click_button "Update"
          expect(page).to have_content("Organization updated successfully")

          organization.reload
          expect(translated(organization.admin_terms_of_use_body)).to eq(
            %(<iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/f6JMgJAQ2tc?showinfo=0"></iframe>)
          )
        end
      end
    end
  end
end
