# frozen_string_literal: true

module VKPM2
  module Organizers
    class UnsetConfigValue
      include Interactor::Organizer

      organize VKPM2::Interactors::ConfigInitialize,
               VKPM2::Interactors::ConfigUnsetKey,
               VKPM2::Interactors::ConfigSave
    end
  end
end
