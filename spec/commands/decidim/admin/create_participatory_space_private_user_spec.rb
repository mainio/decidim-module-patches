# frozen_string_literal: true

require "spec_helper"

module Decidim::Admin
  describe CreateParticipatorySpacePrivateUser do
    subject { described_class.new(form, current_user, privatable_to, via_csv: via_csv) }

    let(:via_csv) { false }
    let(:privatable_to) { create(:participatory_process) }
    let!(:email) { "my_email@example.org" }
    let!(:name) { "Weird Guy" }
    let!(:user) { create(:user, email: "my_email@example.org", organization: privatable_to.organization) }
    let!(:current_user) { create(:user, email: "some_email@example.org", organization: privatable_to.organization) }
    let(:form) do
      double(
        invalid?: invalid,
        delete_current_private_participants?: delete,
        email: email,
        name: name
      )
    end
    let(:delete) { false }
    let(:invalid) { false }

    context "when everything is ok" do
      context "when email is input with case-insensitive letters" do
        let!(:admin) { create(:user, :admin, email: "admin@example.org", organization: privatable_to.organization) }
        let!(:email) { "Admin@example.org" }

        it "still finds the user" do
          expect { subject.call }.to broadcast(:ok)

          participatory_space_private_users = Decidim::ParticipatorySpacePrivateUser.where(user: admin)
          participatory_space_admin = Decidim::User.where(email: "admin@example.org")

          expect(participatory_space_private_users.count).to eq 1
          expect(participatory_space_admin.first.admin?).to be true
        end
      end
    end
  end
end
