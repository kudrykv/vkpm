# frozen_string_literal: true

module VKPM
  module Interactors
    class WebsiteInitialize
      include Interactor
      include Vars::Configs

      def call
        context.website = VKPM::Adapters::Website.new(client:)
      end

      private

      def client
        VKPM::Clients::Website.new(domain:)
      end

      def domain
        config.backend_domain
      end
    end
  end
end
