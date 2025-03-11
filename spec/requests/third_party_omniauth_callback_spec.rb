# frozen_string_literal: true

require "spec_helper"

module Decidim::Patches::Test
  # This controller simulates a customized Omniauth callback flow that would be
  # used by 3rd party login providers. Such providers may need to customize how
  # the login callback is handled based on conditions returned by the Omniauth
  # provider. Customizing the Omniauth strategy is not enough when the login
  # provider needs access to the Decidim context.
  class OmniauthCallbacksController < Decidim::Devise::OmniauthRegistrationsController
    def dev_callback
      create
    end
  end
end

RSpec.describe "Omniauth callback" do
  subject { response.body }

  let(:organization) { create(:organization) }
  let(:omniauth_settings) do
    {
      "omniauth_settings_test_enabled" => true,
      "omniauth_settings_test_icon" => "tools-line"
    }
  end

  let(:user) { create(:user, :confirmed, organization: organization, email: "user@example.org", password: "decidim123456789") }

  let(:oauth_hash) do
    {
      provider: "test",
      uid: uid,
      info: {
        name: name,
        nickname: "custom_auth",
        email: email
      }
    }
  end

  before do
    encrypted_settings = omniauth_settings.transform_values do |v|
      Decidim::OmniauthProvider.value_defined?(v) ? Decidim::AttributeEncryptor.encrypt(v) : v
    end
    organization.update!(omniauth_settings: encrypted_settings)
    host! organization.host
  end

  describe "POST callback" do
    let(:request_path) { "/users/auth/test/callback" }

    let(:uid) { "12345" }
    let(:name) { "Custom Auth" }
    let(:email) { "user@custom.example.org" }

    context "with a new user missing name" do
      let(:name) { nil }

      it "shows the create an account form" do
        get(request_path, env: { "omniauth.auth" => oauth_hash })

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Please complete your profile")
      end
    end

    context "with existing user" do
      let!(:user) { create(:user, organization: organization, email: email) }

      it "redirects to root" do
        get(request_path, env: { "omniauth.auth" => oauth_hash })

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/")
      end
    end

    context "when the user is admin with a pending password change" do
      let!(:user) { create(:user, :confirmed, :admin, organization: organization, email: email, sign_in_count: 1, password_updated_at: 1.year.ago) }

      it "redirects to the /change_password path" do
        get(request_path, env: { "omniauth.auth" => oauth_hash })

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/change_password")
      end
    end
  end
end
