# frozen_string_literal: true

module Decidim
  module Patches
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Patches

      initializer "decidim_patches.api_extensions" do
        Decidim::Api.module_eval do
          config_accessor :disclose_system_version do
            %w(1 true yes).include?(ENV.fetch("DECIDIM_API_DISCLOSE_SYSTEM_VERSION", nil))
          end
        end
      end

      initializer "decidim_patches.signed_global_id", after: "global_id" do |app|
        next if app.config.global_id.fetch(:expires_in, nil).present?

        config.after_initialize do
          SignedGlobalID.expires_in = nil
        end
      end

      initializer "decidim_patches.add_cells_view_paths", before: "add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Patches::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Patches::Engine.root}/app/views")
      end

      config.to_prepare do
        # Helpers
        Decidim::LayoutHelper.include(Decidim::Patches::LayoutHelperExtensions)

        # Commands
        Decidim::Admin::CreateParticipatorySpacePrivateUser.include(
          Decidim::Patches::Admin::CreateParticipatorySpacePrivateUserExtensions
        )
        Decidim::Admin::DestroyComponent.include(
          Decidim::Patches::Admin::DestroyComponentExtensions
        )
        Decidim::Budgets::Admin::ImportProposalsToBudgets.include(
          Decidim::Patches::Admin::ImportProposalsToBudgetsExtensions
        )

        # Forms
        Decidim::Budgets::Admin::ProjectImportProposalsForm.include(
          Decidim::Patches::Admin::ProjectImportProposalsFormExtensions
        )

        # Queries
        Decidim::Admin::NewsletterRecipients.include(
          Decidim::Patches::Admin::NewsletterRecipientsExtensions
        )

        # Models
        Decidim::Budgets::Order.include(Decidim::Patches::OrderExtensions)

        # Controllers
        Decidim::LinksController.include(Decidim::Patches::LinksControllerExtensions)
        Decidim::Budgets::OrdersController.include(Decidim::Patches::OrdersControllerExtensions)
      end
    end
  end
end
