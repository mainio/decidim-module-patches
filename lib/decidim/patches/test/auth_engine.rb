# frozen_string_literal: true

module Decidim
  module Patches
    module Test
      # Example engine overriding the core authentication routes.
      class AuthEngine < ::Rails::Engine
        isolate_namespace Decidim::Patches::Test
        engine_name "decidim_patches_test_auth"

        initializer "decidim_dev_auth.mount_test_routes", before: :add_routing_paths do
          next unless Rails.env.test?

          # Required for overriding the callback route.
          Decidim::Core::Engine.routes.prepend do
            devise_scope :user do
              match(
                "/users/auth/test/callback",
                to: "patches/test/omniauth_callbacks#dev_callback",
                as: "user_test_omniauth_authorize",
                via: [:get, :post]
              )
            end
          end
        end
      end
    end
  end
end
