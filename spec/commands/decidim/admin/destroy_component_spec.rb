# frozen_string_literal: true

require "spec_helper"

module Decidim::Admin
  describe DestroyComponent do
    subject { described_class.new(component, current_user) }

    let!(:component) { create(:component) }
    let!(:current_user) { create(:user, organization: component.participatory_space.organization) }

    context "when everything is ok" do
      context "when the component has a reminder associated with it" do
        let!(:reminder) { create(:reminder, user: current_user, component: component) }

        it "destroys the component" do
          expect { subject.call }.to broadcast(:ok)
          expect(Decidim::Component.where(id: component.id)).not_to exist
        end

        it "destroys the associated reminders" do
          expect { subject.call }.to change(Decidim::Reminder, :count).by(-1)
        end
      end
    end
  end
end
