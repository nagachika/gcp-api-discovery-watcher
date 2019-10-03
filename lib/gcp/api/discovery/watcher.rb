require "optparse"
require "fileutils"
require "open-uri"
require "yaml"

require_relative "watcher/api_metadata"
require_relative "watcher/diff_hash"

module Gcp
  module Api
    module Discovery
      class Watcher
        class Error < StandardError; end

        def fetch_discover_api(api_name, version)
          url = "https://www.googleapis.com/discovery/v1/apis/#{api_name}/#{version}/rest"
          json = URI.open(url){|io| io.read }
          ApiMetadata.new(api_name, version, json)
        end

        def load_file(api_name, version, filepath)
          ApiMetadata.new(api_name, version, File.read(filepath))
        end

        def save_file(filepath, api_metadata)
          FileUtils.mkdir_p(File.dirname(filepath))
          File.write(filepath, YAML.dump(api_metadata.to_hash))
        end

        def parse_options(argv, conf)
          OptionParser.new{|opt|
            opt.on("--api API_NAME", "GCP API Name (ex. ml, bigquery ...)") do |api|
              conf[:api] = api
            end
            opt.on("--api_version API_VERSION", "API version (ex. v1, v1beta1)") do |v|
              conf[:version] = v
            end
            opt.on("--storage DIR") do |dir|
              conf[:dir] = dir
            end
            opt.parse!
          }
          conf
        end

        def current_filename(dir, api, version)
          basedir = File.join(dir, api, version)
          File.join(basedir, "#{api}_#{version}.yaml")
        end

        def metadata_filename(dir, metadata)
          File.join(dir, metadata.api, metadata.version, "#{metadata.api}_#{metadata.version}_#{metadata.revision}.yaml")
        end

        def run(argv)
          conf = {
            dir: "./cache"
          }
          conf = parse_options(argv, conf)

          current_path = current_filename(conf[:dir], conf[:api], conf[:version])
          previous = nil
          if File.readable?(current_path)
            previous = load_file(conf[:api], conf[:version], current_path)
          end

          new_metadata = fetch_discover_api(conf[:api], conf[:version])

          write_current = false
          write_new_metadata = true
          if previous
            if previous.revision == new_metadata.revision
              puts "API #{conf[:api]}_#{conf[:version]}: No Change (revision #{new_metadata.revision})"
              write_new_metadata = false
            else
              if previous.revision < new_metadata.revision
                write_current = true
              end
              puts "API #{conf[:api]}_#{conf[:version]}: revision #{previous.revision} -> #{new_metadata.revision}"
              DiffHash.diff_hash(previous, new_metadata)
            end
          else
            puts "New API #{conf[:api]}_#{conf[:version]}"
            write_current = true
          end

          if write_current
            save_file(current_path, new_metadata)
          end
          if write_new_metadata
            save_file(metadata_filename(conf[:dir], new_metadata), new_metadata)
          end
        end
      end
    end
  end
end
