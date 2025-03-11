# frozen_string_literal: true

require "spec_helper"

module Decidim::Admin
  describe NewsletterRecipients do
    subject { described_class.new(form) }

    let(:newsletter) { create(:newsletter) }
    let(:organization) { newsletter.organization }
    let(:send_to_all_users) { true }
    let(:send_to_followers) { false }
    let(:send_to_participants) { false }
    let(:participatory_space_types) { [] }
    let(:scope_ids) { [] }

    let(:form_params) do
      {
        send_to_all_users: send_to_all_users,
        send_to_followers: send_to_followers,
        send_to_participants: send_to_participants,
        participatory_space_types: participatory_space_types,
        scope_ids: scope_ids
      }
    end

    let(:form) do
      SelectiveNewsletterForm.from_params(
        form_params
      ).with_context(
        current_organization: organization
      )
    end

    describe "querying recipients" do
      context "when sending to all users" do
        let!(:recipients) { create_list(:user, 5, :confirmed, newsletter_notifications_at: Time.current, organization: organization) }

        context "with blocked accounts" do
          let!(:blocked_recipients) { create_list(:user, 5, :confirmed, :blocked, newsletter_notifications_at: Time.current, organization: organization) }

          it "returns all not blocked users" do
            expect(subject.query).to match_array recipients
            expect(recipients.count).to eq 5
          end
        end
      end
    end
  end
end
