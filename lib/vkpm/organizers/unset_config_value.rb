# frozen_string_literal: true

module VKPM
  module Organizers
    class UnsetConfigValue
      include Interactor::Organizer

      organize VKPM::Interactors::ConfigInitialize,
               VKPM::Interactors::ConfigUnsetKey,
               VKPM::Interactors::ConfigSave
    end
  end
end
