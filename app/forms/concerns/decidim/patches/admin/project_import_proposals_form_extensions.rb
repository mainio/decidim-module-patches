# frozen_string_literal: true

module Decidim
  module Patches
    module Admin
      module ProjectImportProposalsFormExtensions
        extend ActiveSupport::Concern

        included do
          def scope
            @scope ||= @attributes["scope_id"].value ? current_component.scopes.find_by(id: @attributes["scope_id"].value) : current_component.scope
          end
        end
      end
    end
  end
end
