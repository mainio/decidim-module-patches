# frozen_string_literal: true

module Decidim
  module Patches
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Patches

      config.to_prepare do
        # Commands
        Decidim::Admin::CreateParticipatorySpacePrivateUser.include(
          Decidim::Patches::Admin::CreateParticipatorySpacePrivateUserExtensions
        )

        # Queries
        Decidim::Admin::NewsletterRecipients.include(
          Decidim::Patches::Admin::NewsletterRecipientsExtensions
        )

        # Lib
        Decidim::FormBuilder.include(Decidim::Patches::FormBuilderExtensions)
      end
    end
  end
end
