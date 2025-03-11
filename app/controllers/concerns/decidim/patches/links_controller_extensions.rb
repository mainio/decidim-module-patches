# frozen_string_literal: true

module Decidim
  module Patches
    module LinksControllerExtensions
      extend ActiveSupport::Concern

      included do
        def new
          headers["X-Robots-Tag"] = "none"
          headers["Link"] = %(<#{url_for}>; rel="canonical")
        end
      end
    end
  end
end
