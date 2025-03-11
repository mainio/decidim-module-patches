# frozen_string_literal: true

module Decidim
  module Patches
    module Admin
      module CreateParticipatorySpacePrivateUserExtensions
        extend ActiveSupport::Concern

        included do
          private

          def existing_user
            return @existing_user if defined?(@existing_user)

            collection = Decidim::User
            collection = collection.entire_collection if collection.respond_to?(:entire_collection)
            @existing_user = collection.find_by(
              email: form.email.downcase,
              organization: private_user_to.organization
            )

            InviteUserAgain.call(@existing_user, invitation_instructions) if @existing_user&.invitation_pending?

            @existing_user
          end
        end
      end
    end
  end
end
