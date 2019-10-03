#!/usr/bin/env ruby

require "diffy"
require "json"
require "tmpdir"
require "pp"
require "optparse"

module Gcp
  module Api
    module Discovery
      class Watcher
        module DiffHash
          module_function

          def diff_hash(a, b, port=$stdout, current_keys=[])
            a = a.to_hash
            b = b.to_hash
            a_keys = a.keys.sort
            b_keys = b.keys.sort
            (a_keys - b_keys).each do |k|
              port << "\n--- '#{(current_keys+[k]).join(".")}':"
              port << a[k].pretty_inspect
            end
            (b_keys - a_keys).each do |k|
              port << "\n+++ '#{(current_keys+[k]).join(".")}':"
              port << b[k].pretty_inspect
            end
            (a_keys & b_keys).each do |k|
              unless a[k] == b[k]
                if a[k].is_a?(Hash) and b[k].is_a?(Hash)
                  diff_hash(a[k], b[k], port, current_keys + [k])
                else
                  port << "\n'#{(current_keys+[k]).join(".")}' is changed:\n"
                  if a[k].is_a?(String) and b[k].is_a?(String)
                    port << Diffy::Diff.new(a[k], b[k]).to_s
                  else
                    port << "--- #{a[k].to_json}\n"
                    port << "+++ #{b[k].to_json}\n"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
