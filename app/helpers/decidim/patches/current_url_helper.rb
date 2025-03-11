# frozen_string_literal: true

module Decidim
  module Patches
    module CurrentUrlHelper
      def current_url(params = request.parameters)
        return url_for(params) if respond_to?(:current_participatory_space) || respond_to?(:current_component)

        each_decidim_engine do |helpers|
          return helpers.url_for(params)
        rescue ActionController::UrlGenerationError
          # Continue to next engine in case the URL is not available.
        end

        main_app.url_for(params)
      rescue ActionController::UrlGenerationError
        "#{request.base_url}#{"?#{params.to_query}" unless params.empty?}"
      end

      private

      def each_decidim_engine
        Rails.application.railties.each do |engine|
          next unless engine.is_a?(Rails::Engine)
          next unless engine.isolated?
          next unless engine.engine_name.start_with?("decidim_")
          next unless respond_to?(engine.engine_name)

          yield public_send(engine.engine_name)
        end
        return unless respond_to?(:decidim)

        yield decidim
      end
    end
  end
end
