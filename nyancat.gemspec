Gem::Specification.new do |s|
  s.name        = 'nyancat'
  s.version     = '0.2.0'
  s.date        = '2013-02-01'
  s.summary     = "nyancat on your terminal"
  s.description = "A Ruby port of Kevin Lange's nyancat"
  s.authors     = ["Ben Arblaster"]
  s.email       = 'ben@andatche.com'
  s.files       = ["lib/nyancat.rb"] + Dir["lib/nyancat/**/*"]
  s.executables << 'nyancat'
  s.homepage    = 'https://github.com/andatche/ruby_nyancat/'
  s.add_dependency 'gserver'
end
