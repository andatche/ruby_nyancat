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

module NyanCat

  OUTPUT_CHAR = "  "

  def self.nyancat(frames, palette)
    
    # Get TTY size
    term_width, term_height = `stty size`.split.map { |x| x.to_i }.reverse

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
      end.join + "\033[H"
    end

    start_time = Time.now
    printf("\033[H\033[2J\033[?25l")
    begin
      loop do
        frames.each do |frame|
          print frame
          sleep(0.09)
        end
      end
    rescue SignalException => e
      printf("\033c\033c")
      printf("YOU NYANED FOR %4.2f SECONDS\n", Time.now - start_time)
    rescue Exception => e
      printf("\033c")
      puts "Oops, something went wrong..."
      raise e
    end
  end
end 
