# frozen_string_literal: true

require "spec_helper"

module Decidim::Devise
  describe SessionsController, type: :controller do
    routes { Decidim::Core::Engine.routes }

    describe "after_sign_in_path_for" do
      subject { controller.after_sign_in_path_for(user) }

      before do
        request.env["decidim.current_organization"] = user.organization
      end

      context "when the given resource is a user" do
        context "and is an admin" do
          let(:user) { build(:user, :admin, sign_in_count: 1) }

          before do
            controller.store_location_for(user, account_path)
          end

          it { is_expected.to eq account_path }

          context "and has pending password change" do
            let(:user) { build(:user, :admin, sign_in_count: 1, password_updated_at: 2.years.ago) }

            it do
              expected_path = change_password_path

              expect(controller).not_to receive(:change_password_path)
              expect(subject).to eq(expected_path)
            end
          end
        end
      end
    end
  end
end
