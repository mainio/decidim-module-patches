# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

module Decidim::Core
  describe DecidimType do
    subject { described_class }

    include_context "with a graphql class type"

    let(:model) do
      Decidim
    end

    describe "version" do
      let(:query) { "{ version }" }

      it "returns the version" do
        expect(response).to eq("version" => nil)
      end

      context "when disclosing system version is enabled" do
        before do
          allow(Decidim::Api).to receive(:disclose_system_version).and_return(true)
        end

        it "returns the version" do
          expect(response).to eq("version" => Decidim.version)
        end
      end
    end
  end
end
