# frozen_string_literal: true

module Decidim
  module Patches
    module FormBuilderExtensions
      extend ActiveSupport::Concern

      included do
        def sanitize_editor_value(value)
          sanitized_value = decidim_sanitize_editor_admin(value)
          # Do not call the `decidim_sanitize_editor_admin` here because it would
          # disable the iframe elements from the editable areas that are shown to
          # admins causing all videos to be removed in case the admin has not given
          # full consent to cookies.
          sanitized_value = decidim_sanitize_editor(value, { scrubber: Decidim::AdminInputScrubber.new })

          sanitized_value == %(<div class="ql-editor-display"></div>) ? "" : sanitized_value
        end
      end
    end
  end
end
