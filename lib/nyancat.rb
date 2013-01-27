#  Copyright (c) 2011 Ben Arblaster.  All rights reserved.
#  Copyright (c) 2011 Kevin Lange.  All rights reserved.
# 
#  Original implementation Developed by: Kevin Lange
#                http://github.com/klange/nyancat
#  Ruby port by: Ben Arblaster
#                http://github.com/andatche/ruby_nyancat
# 
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to
#  deal with the Software without restriction, including without limitation the
#  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
#  sell copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#    1. Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimers.
#    2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimers in the
#       documentation and/or other materials provided with the distribution.
#    3. Neither the names of the Association for Computing Machinery, Kevin
#       Lange, nor the names of its contributors may be used to endorse
#       or promote products derived from this Software without specific prior
#       written permission.
# 
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
#  CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
#  WITH THE SOFTWARE.

require 'yaml'

module NyanCat
  OUTPUT_CHAR = "  "

  def self.flavours
    return Dir.entries(File.expand_path("../nyancat/", __FILE__)).select { |entry| !(entry =='.' || entry == '..') }
  end

  def self.nyancat(io, options = {})
    term_width = options[:width] || 80
    term_height = options[:height] || 24
    flavour = options[:flavour] || 'original'
    mute = options[:mute] || false
    hide_time = options[:hide_time] || false

    frames  = YAML.load_file(File.expand_path("../nyancat/#{flavour}/frames.yml", __FILE__))
    palette = YAML.load_file(File.expand_path("../nyancat/#{flavour}/palette.yml", __FILE__))

    # Calculate the width in terms of the output char
    term_width = term_width / OUTPUT_CHAR.length

    min_row = 0
    max_row = frames[0].length

    min_col = 0
    max_col = frames[0][0].length

    min_row = (max_row - term_height) / 2 if max_row > term_height
    max_row = min_row + term_height if max_row > term_height

    min_col = (max_col - term_width) / 2 if max_col > term_width
    max_col = min_col + term_width if max_col > term_width

    frames = frames.map do |frame|
      frame[min_row...max_row].map do |line|
        line.chars.to_a[min_col...max_col].map do |c|
          "\033[48;5;%dm%s" % [palette[c], OUTPUT_CHAR]
        end.join + "\033[m\n"
      end
    end
    
    # Initialise term
    io.printf("\033[H\033[2J\033[?25l")

    # Get start time
    start_time = Time.now()

    loop do
      frames.each do |frame|
        # Print the next frame
        io.puts frame

        # Print the time so far
        unless hide_time
          time = "You have nyaned for %0.0f seconds!" % [Time.now() - start_time]
          time = time.center(term_width * OUTPUT_CHAR.length)
          io.printf("\033[1;37;17m%s", time)
        end

        # Reset the frame and sleep
        io.printf("\033[H")
        sleep(0.09)
      end
    end
  end

  def self.reset(io)
    io.printf("\033[0m\033c")
  end

  def self.audio(options = {})
    flavour = options[:flavour] || 'original'
    audio = File.expand_path("../nyancat/#{flavour}/audio.mp3", __FILE__)

    IO.popen("mpg123 -loop 0 -q #{audio} > /dev/null 2>&1")
  end

end
