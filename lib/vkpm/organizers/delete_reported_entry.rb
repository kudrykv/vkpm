# frozen_string_literal: true

module VKPM
  module Organizers
    class DeleteReportedEntry
      include Interactor::Organizer

      organize VKPM::Interactors::ConfigInitialize,
               VKPM::Interactors::WebsiteInitialize,
               VKPM::Interactors::WebsiteAuth,
               VKPM::Interactors::ReportedEntryDelete
    end
  end
end
