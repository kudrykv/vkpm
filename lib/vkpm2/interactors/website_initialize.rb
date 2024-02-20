# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsiteInitialize
      include Interactor
      include Vars::Configs

      def call
        context.website = VKPM2::Adapters::Website.new(client:)
      end

      private

      def client
        VKPM2::Clients::Website.new(domain:)
      end

      def domain
        config.backend_domain
      end
    end
  end
end
