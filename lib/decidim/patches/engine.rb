# frozen_string_literal: true

module Decidim
  module Patches
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Patches
    end
  end
end
