# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Map
    module Provider
      module DynamicMap
        describe Here do
          include_context "with map utility" do
            subject { utility }
          end

          describe "#builder_class" do
            it "returns the Builder class under the given module" do
              expect(utility.builder_class).to be(
                Decidim::Map::Provider::DynamicMap::Here::Builder
              )
            end
          end

          describe "#builder_options" do
            let(:config) do
              {
                api_key: "key1234",
                tile_layer: { foo: "bar" }
              }
            end

            it "returns the correct builder options" do
              expect(subject.builder_options).to eq(
                marker_color: "#ef604d",
                tile_layer: {
                  api_key: "key1234", foo: "bar", language: "en"
                }
              )
            end

            context "with different locale configuration" do
              before do
                allow(I18n.config).to receive(:enforce_available_locales).and_return(false)
              end

              it "returns the correct builder options for CA" do
                I18n.with_locale("ca") do
                  expect(subject.builder_options).to eq(
                    marker_color: "#ef604d",
                    tile_layer: {
                      api_key: "key1234", foo: "bar", language: "ca"
                    }
                  )
                end
              end

              it "returns the correct builder options for ES" do
                I18n.with_locale("es") do
                  expect(subject.builder_options).to eq(
                    marker_color: "#ef604d",
                    tile_layer: {
                      api_key: "key1234", foo: "bar", language: "es"
                    }
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
