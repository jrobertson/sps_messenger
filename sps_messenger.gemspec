Gem::Specification.new do |s|
  s.name = 'sps_messenger'
  s.version = '0.1.0'
  s.summary = 'Subscribes to SPS messages intended for a human.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/sps_messenger.rb']
  s.add_runtime_dependency('sps-sub', '~> 0.3', '>=0.3.6')
  s.signing_key = '../privatekeys/sps_messenger.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/sps_messenger'
end
