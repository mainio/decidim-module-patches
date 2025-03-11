# frozen_string_literal: true

module Decidim
  module Patches
    module Admin
      module NewsletterRecipientsExtensions
        extend ActiveSupport::Concern

        included do
          def query
            recipients = recipients_base_query

            recipients = recipients.interested_in_scopes(@form.scope_ids) if @form.scope_ids.present?

            followers = recipients.where(id: user_id_of_followers) if @form.send_to_followers

            participants = recipients.where(id: participant_ids) if @form.send_to_participants

            recipients = participants if @form.send_to_participants
            recipients = followers if @form.send_to_followers
            recipients = (followers + participants).uniq if @form.send_to_followers && @form.send_to_participants

            recipients
          end
        end

        private

        def recipients_base_query
          Decidim::User.available
                       .where(organization: @form.current_organization)
                       .where.not(newsletter_notifications_at: nil)
                       .where.not(email: nil)
                       .confirmed
        end
      end
    end
  end
end
