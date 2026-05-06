# frozen_string_literal: true

module Decidim
  module Patches
    # Fixes a bug in the orders controller storing the previous URLs.
    module OrdersControllerExtensions
      extend ActiveSupport::Concern

      included do
        skip_before_action :store_current_location
      end
    end
  end
end
