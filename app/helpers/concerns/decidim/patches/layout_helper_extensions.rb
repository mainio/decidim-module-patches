# frozen_string_literal: true

module Decidim
  module Patches
    module LayoutHelperExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::Patches::CurrentUrlHelper
      end
    end
  end
end
