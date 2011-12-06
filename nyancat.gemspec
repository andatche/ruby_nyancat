Gem::Specification.new do |s|
  s.name        = 'nyancat'
  s.version     = '0.0.3'
  s.date        = '2011-12-06'
  s.summary     = "nyancat on your terminal"
  s.description = "A Ruby port of Kevin Lange's nyancat"
  s.authors     = ["Ben Arblaster"]
  s.email       = 'ben@andatche.com'
  s.files       = ["lib/nyancat.rb", "lib/nyancat/frames.yml", "lib/nyancat/palette.yml"]
  s.executables << 'nyancat'
  s.homepage    = 'https://github.com/andatche/ruby_nyancat/'
end
