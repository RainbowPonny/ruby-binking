# frozen_string_literal: true

module Binking
  module RequestResource
    extend self

    RESOURCES_KEYS = {
      "bank" => "bankAlias",
      "banks" => "banksAliases",
      "form" => "cardNumber"
    }.freeze

    def get(resource, value, fields: [], sandbox: false)
      fields = fields.map(&:to_s) & FIELDS
      params = {}
      params[RESOURCES_KEYS[resource.to_s]] = value
      params[:fields] = fields.join(",") unless fields.empty?

      Client.new(sandbox: sandbox)
            .get("/#{resource}", params)
            .body
    end
  end
end
