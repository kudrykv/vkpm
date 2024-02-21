# frozen_string_literal: true

module VKPM
  module Organizers
    class ReportHours
      include Interactor::Organizer

      organize VKPM::Interactors::ConfigInitialize,
               VKPM::Interactors::WebsiteInitialize,
               VKPM::Interactors::WebsiteAuth,
               VKPM::Interactors::ReportHoursSettleProject,
               VKPM::Interactors::ReportHoursSettleActivity,
               VKPM::Interactors::WebsitePullReportedEntries,
               VKPM::Interactors::ReportHoursSettleTask,
               VKPM::Interactors::ReportHours,
               VKPM::Interactors::WebsitePullReportedEntries,
               VKPM::Interactors::ReportHoursFindReportedEntry
    end
  end
end
