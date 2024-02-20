# frozen_string_literal: true

module VKPM2
  module Organizers
    class ReportHours
      include Interactor::Organizer

      organize VKPM2::Interactors::ConfigInitialize,
               VKPM2::Interactors::WebsiteInitialize,
               VKPM2::Interactors::WebsiteAuth,
               VKPM2::Interactors::ReportHoursSettleProject,
               VKPM2::Interactors::ReportHoursSettleActivity
    end
  end
end
