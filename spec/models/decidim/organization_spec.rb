# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Organization do
    subject(:organization) { build(:organization) }

    describe "#to_sgid" do
      subject { sgid }

      let(:organization) { create(:organization) }
      let(:sgid) { travel_to(5.years.ago) { organization.to_sgid.to_s } }

      it "does not expire" do
        located = GlobalID::Locator.locate_signed(subject)
        expect(located).to eq(organization)
      end
    end
  end
end
