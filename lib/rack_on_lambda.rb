# frozen_string_literal: true

require 'base64'

require 'active_support/hash_with_indifferent_access'
require 'rack/body_proxy'
require 'rack/utils'
require 'rack/version'

require 'pry' if Gem.loaded_specs.key?('pry')

require_relative 'rack_on_lambda/version'

require_relative 'rack_on_lambda/response'
require_relative 'rack_on_lambda/query'
require_relative 'rack_on_lambda/adapters/rest_api'
require_relative 'rack_on_lambda/handlers/rest_api'

module RackOnLambda; end
