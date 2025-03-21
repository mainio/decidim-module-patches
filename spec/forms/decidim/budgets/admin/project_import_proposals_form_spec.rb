# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Budgets
    module Admin
      describe ProjectImportProposalsForm do
        subject { form }

        let(:project) { create(:project) }
        let(:component) { project.component }
        let(:origin_component) { create(:proposal_component, participatory_space: component.participatory_space) }
        let(:default_budget) { 1000 }
        let(:scope_id) { nil }
        let(:import_all_accepted_proposals) { true }
        let(:params) do
          {
            origin_component_id: origin_component.try(:id),
            default_budget: default_budget,
            import_all_accepted_proposals: import_all_accepted_proposals,
            scope_id: scope_id
          }
        end

        let(:form) do
          described_class.from_params(params).with_context(
            current_component: component,
            current_participatory_space: component.participatory_space
          )
        end

        describe "#scope" do
          subject { form.scope }

          let(:space_scope) { create(:scope, organization: component.organization) }
          let(:component_scope) { create(:scope, organization: component.organization, parent: space_scope) }
          let(:project_scope) { create(:scope, organization: component.organization, parent: component_scope) }

          context "when the scope is not defined" do
            it "returns nil" do
              expect(subject).to be_nil
            end

            context "and the component has a scope" do
              before do
                component.participatory_space.update!(scope: space_scope)

                settings = component.settings
                settings.scope_id = component_scope.id
                settings.scopes_enabled = true
                component.settings = settings
                component.save!
              end

              it "returns the component's scope" do
                expect(subject).to eq(component_scope)
              end
            end
          end

          context "when the scope is defined" do
            let(:scope_id) { project_scope.id }

            it "returns the scope" do
              expect(subject).to eq(project_scope)
            end
          end
        end
      end
    end
  end
end
