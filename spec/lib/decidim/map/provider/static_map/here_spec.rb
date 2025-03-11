# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Map
    module Provider
      module StaticMap
        describe Here do
          let(:latitude) { 60.149790 }
          let(:longitude) { 24.887430 }
          let(:api_key) { "key1234" }

          include_context "with map utility" do
            subject { utility }

            let(:config) { { api_key: api_key, url: "https://image.maps.hereapi.com/mia/v3/base/mc/overlay" } }
          end

          describe "#url" do
            let(:expected_params) do
              {
                apiKey: api_key,
                overlay: "point:#{latitude},#{longitude};icon=cp;size=large|#{latitude},#{longitude};style=circle;width=50m;color=%231B9D2C60"
              }
            end

            it "returns an expected URL format with the v3 API URL" do
              expect(subject.url(latitude: latitude, longitude: longitude)).to eq(
                "https://image.maps.hereapi.com/mia/v3/base/mc/overlay:radius=90/120x120/png8?#{URI.encode_www_form(expected_params)}"
              )
            end
          end

          describe "#url_params" do
            it "shows a deprecation warning" do
              expect(ActiveSupport::Deprecation).to receive(:warn)

              subject.url_params(latitude: latitude, longitude: longitude)
            end
          end
        end
      end
    end
  end
end
