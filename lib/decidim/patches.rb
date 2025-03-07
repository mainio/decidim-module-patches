# frozen_string_literal: true

require_relative "patches/version"
require_relative "patches/engine"

module Decidim
  module Patches
    include ActiveSupport::Configurable
  end
end
