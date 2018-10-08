# frozen_string_literal: true

require_relative './configuration_validator'

module Reek
  module Configuration
    #
    # Array extension for excluded paths.
    #
    module ExcludedPaths
      include ConfigurationValidator

      # @param paths [String]
      # @return [undefined]
      def add(paths)
        paths.map {|path| Pathname(path) }.each do |path|
          raise "Path #{path} does not exist" unless path.exist?
          self << path
        end
      end
    end
  end
end
