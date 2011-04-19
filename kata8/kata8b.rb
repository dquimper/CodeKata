require 'kata8a'

# Here I used class heritage for clarity only. Some of the methods from
# Kata8a are not re-implemented. So I did not copy them here. This is
# so you don't spend time searching for differences from Kata8a when
# there are none.

class Kata8b < Kata8a

#  def initialize(maxlen)      # not re-implemented

  # about 4ms faster on my machine.
  def load_dict()
    File.open("wordlist.txt") do |f|
      f.readlines.each do |line|
        # using chomp! instead of strip! as we only need to remove the 'end of line' character.
        line.chomp!
        lsize = line.size
        if lsize == @maxlen
          line.downcase!               # downcasing only strings of 6 chars
          @targetwords[line] = []
        elsif lsize < @maxlen
          line.downcase!               # and downcasing only strings shorter than 6 chars
          @wordhash[lsize] << line
        end
      end
    end
  end

  # Here on my windows machine, after a few experiments,
  # I discovered that allocating a variable to store the result
  # of w1+w2 was actually slower than concatenating them twice.
  # This way I gain about 50ms on my machine just for w1+w2.
  def combine(w1list, w2list)
    w1list.each do |w1|
      w2list.each do |w2|
        if @targetwords.include?(w1+w2)
          @targetwords[w1+w2] << [w1, w2]
        end
      end
    end
  end

  # Here I optimized my code to take advantage of the IO buffer.
  # One large write to disk is faster than 1536 shorter writes.
  # This way I gain 1ms on my machine.
  # I can also increase speed further by removing the counter as
  # it is not required.
  def print_words
    i = 0
    out = ""
    @targetwords.each do |w, l|
      l.each do |w1, w2|
        i += 1
        out << "#{w1} + #{w2} => #{w}\n"
      end
    end
    File.open("output.txt", "w") do |f|
      f.puts out
    end
    puts "Number of combinations found: #{i}"
  end

end

if __FILE__ == $0
  3.times do
    Timer.timer_msg("Kata8b - Execution time") do
      Kata8b.runner(6)
    end
    puts ""
  end
  Timer.report
  waiting_prompt()
end

# Executing this on my Windows machine at home produced
# the following:

#init_vars(): 0.0 msecs
#load_dict(): 69.0 msecs
#combine_all(): 412.0 msecs
#Number of combinations found: 1536
#print_words(): 9.0 msecs
#Kata8b - Execution time: 492.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 76.0 msecs
#combine_all(): 401.0 msecs
#Number of combinations found: 1536
#print_words(): 9.0 msecs
#Kata8b - Execution time: 486.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 72.0 msecs
#combine_all(): 403.0 msecs
#Number of combinations found: 1536
#print_words(): 9.0 msecs
#Kata8b - Execution time: 484.0 msecs
#
#init_vars(): avg: 0.0 msecs (n: 3)
#load_dict(): avg: 72.3333333333334 msecs (n: 3)
#combine_all(): avg: 405.333333333333 msecs (n: 3)
#print_words(): avg: 9.0 msecs (n: 3)
#Kata8b - Execution time: avg: 487.333333333333 msecs (n: 3)
#All done - press any key to end


