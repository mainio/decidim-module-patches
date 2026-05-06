# frozen_string_literal: true

module Decidim
  module Patches
    # Fixes an issue that an non-logged in user can see the vote modal.
    module OrderExtensions
      extend ActiveSupport::Concern

      included do
        alias_method :patches_orig_can_checkout?, :can_checkout? unless method_defined?(:patches_orig_can_checkout?)

        # Public: Check if the order total budget is enough to checkout
        def can_checkout?
          return false unless user

          patches_orig_can_checkout?
        end
      end
    end
  end
end
