# frozen_string_literal: true

module VKPM2
  module Organizers
    class AuthLogin
      include Interactor::Organizer

      organize Interactors::ConfigInitialize,
               Interactors::WebsiteInitialize,
               Interactors::WebsiteLogin,
               Interactors::ConfigSetKeyValue,
               Interactors::ConfigSave
    end
  end
end
