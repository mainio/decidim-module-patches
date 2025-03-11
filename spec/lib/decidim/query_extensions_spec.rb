# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

module Decidim
  module Core
    describe Decidim::Api::QueryType do
      include_context "with a graphql class type"

      describe "decidim" do
        let(:query) { %({ decidim { version }}) }

        it "returns nil" do
          expect(response["decidim"]).to include("version" => nil)
        end

        context "when disclosing system version is enabled" do
          before do
            allow(Decidim::Api).to receive(:disclose_system_version).and_return(true)
          end

          it "returns the right version" do
            expect(response["decidim"]).to include("version" => Decidim.version)
          end
        end
      end
    end
  end
end
