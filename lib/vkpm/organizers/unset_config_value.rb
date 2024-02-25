# frozen_string_literal: true

module VKPM
  module Organizers
    class UnsetConfigValue
      include Interactor::Organizer

      organize VKPM::Interactors::ConfigInitialize,
               VKPM::Interactors::ConfigUnsetKey
    end
  end
end
