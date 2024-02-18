# frozen_string_literal: true

module VKPM2
  module Organizers
    class SetConfigValue
      include Interactor::Organizer

      organize Interactors::ConfigInitialize,
               Interactors::ConfigSetKeyValue,
               Interactors::ConfigSave
    end
  end
end
