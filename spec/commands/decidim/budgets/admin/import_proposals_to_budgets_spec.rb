# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Budgets
    module Admin
      describe ImportProposalsToBudgets do
        describe "call" do
          let!(:proposals) { create_list(:proposal, 3, :accepted, component: proposals_component) }
          let(:proposals_component) { create(:proposal_component) }

          let!(:proposal) { proposals.first }
          let(:current_component) do
            create(
              :component,
              manifest_name: "budgets",
              participatory_space: proposal.component.participatory_space
            )
          end
          let(:budget) { create :budget, component: current_component }
          let!(:current_user) { create(:user, :admin, organization: current_component.participatory_space.organization) }
          let!(:organization) { current_component.participatory_space.organization }
          let(:scope) { nil }
          let!(:form) do
            instance_double(
              ProjectImportProposalsForm,
              origin_component: proposals_component,
              current_component: current_component,
              current_user: current_user,
              default_budget: default_budget,
              import_all_accepted_proposals: import_all_accepted_proposals,
              scope_id: scope,
              budget: budget,
              valid?: valid
            )
          end

          let(:default_budget) { 1000 }
          let(:import_all_accepted_proposals) { true }

          let(:command) { described_class.new(form) }

          shared_context "with scoped proposals" do
            let(:scope) { create(:scope, organization: organization) }
            let(:scoped_proposals) { proposals[0..1] }

            before do
              current_component.participatory_space.update!(scope: space_scope) if respond_to?(:space_scope)

              settings = current_component.settings
              settings.scope_id = component_scope.id if respond_to?(:component_scope)
              settings.scopes_enabled = true
              current_component.settings = settings
              current_component.save!

              scoped_proposals.each { |pr| pr.update!(decidim_scope_id: scope.id) }
            end
          end

          describe "when the form is valid" do
            let(:valid) { true }

            it "creates the projects" do
              expect { command.call }.to change { Project.where(budget: budget).count }.by(3)
            end

            context "when a scope is defined" do
              include_context "with scoped proposals"

              it "only imports the proposals mapped to the defined scope" do
                expect { command.call }.to(change { Project.where(budget: budget).where(scope: scope).count }.by(scoped_proposals.count))
              end
            end

            context "when a proposal was already imported" do
              let(:second_proposal) { create(:proposal, :accepted, component: proposal.component) }

              before do
                command.call
                second_proposal
              end

              context "when the proposal does not have a cost" do
                let!(:proposals) { create_list(:proposal, 3, :accepted, cost: nil, component: proposals_component) }

                it "imports the default budget" do
                  command.call

                  new_project = Project.where(budget: budget).order(:id).first
                  expect(new_project.budget_amount).to eq(default_budget)
                end
              end
            end

            context "when proposals were already imported to another budget within the same component" do
              let(:another_budget) { create(:budget, component: current_component) }
              let!(:mapped_projects) do
                proposals.map do |pr|
                  project = create(:project, title: pr.title, description: pr.body, budget: another_budget)
                  project.link_resources([pr], "included_proposals")
                  project
                end
              end

              it "does not import it again" do
                expect { command.call }.not_to(change { Project.where(budget: budget).count })
              end
            end

            it "links the proposals" do
              command.call
              last_project = Project.where(budget: budget).order(:id).first

              linked = last_project.linked_resources(:proposals, "included_proposals")

              expect(linked).to include(proposal)
            end
          end
        end
      end
    end
  end
end
