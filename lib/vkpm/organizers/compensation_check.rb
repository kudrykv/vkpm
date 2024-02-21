# frozen_string_literal: true

module VKPM
  module Organizers
    class CompensationCheck
      include Interactor::Organizer

      organize VKPM::Interactors::ConfigInitialize,
               VKPM::Interactors::WebsiteInitialize,
               VKPM::Interactors::WebsiteAuth,
               VKPM::Interactors::Compensation
    end
  end
end
