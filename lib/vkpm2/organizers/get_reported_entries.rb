# frozen_string_literal: true

module VKPM2
  module Organizers
    class GetReportedEntries
      include Interactor::Organizer

      organize Interactors::ConfigInitialize,
               Interactors::WebsiteInitialize,
               Interactors::WebsiteAuth
    end
  end
end
