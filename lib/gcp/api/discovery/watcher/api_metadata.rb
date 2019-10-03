# frozen-string-literal: true

require "yaml"

module Gcp
  module Api
    module Discovery
      class Watcher
        class ApiMetadata
          def initialize(api, version, obj_or_yaml_string)
            case obj_or_yaml_string
            when String
              obj = YAML.safe_load(obj_or_yaml_string)
            when Hash
              obj = obj_or_yaml_string
            else
              raise ArgumentError, "ApiMetadata.new accept String or Hash"
            end
            @api = api
            @version = version
            @obj = obj.sort.each_with_object({}){|(k, v), t| t[k] = v }
            @revision = obj["revision"]
          end

          attr_reader :api, :version, :obj, :revision

          def to_hash
            self.obj
          end
        end
      end
    end
  end
end
