require 'bundler/setup'
Bundler.require(:default)

require 'minitest/spec'
require 'minitest-spec-context'
require 'minitest/autorun'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

ENV['CANVAS_URL'] = 'http://localhost:3000'
ENV['CANVAS_TOKEN'] = '5h98vhxHhFSF4zkpjN5UCTdATtRDP34ANHaMhSgFSgDihRy1HFXnyg4I4s2bLJ94'
ENV['CANVAS_ACCOUNT'] = '1'

require 'canvas_client'