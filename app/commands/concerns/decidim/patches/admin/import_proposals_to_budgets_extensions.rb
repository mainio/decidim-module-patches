# frozen_string_literal: true

module Decidim
  module Patches
    module Admin
      module ImportProposalsToBudgetsExtensions
        extend ActiveSupport::Concern

        included do
          private

          def all_proposals
            Decidim::Proposals::Proposal.where(component: origin_component).published.not_hidden.except_withdrawn.accepted.order(:published_at)
          end

          def proposal_already_copied?(original_proposal)
            # Note: we are including also projects from unpublished components
            # because otherwise duplicates could be created until the component is
            # published.
            original_proposal.linked_resources(:projects, "included_proposals", component_published: false).any? do |project|
              component_budgets.exists?(project.decidim_budgets_budget_id)
            end
          end

          def component_budgets
            @component_budgets ||= Decidim::Budgets::Budget.where(component: form.budget.component)
          end
        end
      end
    end
  end
end
