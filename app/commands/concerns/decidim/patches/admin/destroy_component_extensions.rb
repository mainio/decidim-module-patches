# frozen_string_literal: true

module Decidim
  module Patches
    module Admin
      module DestroyComponentExtensions
        extend ActiveSupport::Concern

        included do
          private

          def run_before_hooks
            Decidim::Reminder.where(component: @component).destroy_all
            @component.manifest.run_hooks(:before_destroy, @component)
          end
        end
      end
    end
  end
end
