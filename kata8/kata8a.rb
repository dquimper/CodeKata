require "#{File.dirname(__FILE__)}/../lib/timer"

# Starting a new projet, I try to follow the "Make It Work",
# "Make It Right", "Make It Fast".

# Kata8a is the "Make It Work" and "Make It Right" part.
#    A sure way to make it work is to write code as clear as possible
#    so it's easy to understand. Then we can refactor the code
#    to make it right.
# Kata8b is the "Make It Fast"
#    I optimized as much as I could the Kata8a.
# Kata8c is an attempt to use the computer architecture to acquire
# further speed.

class Kata8a

  def self.runner(maxlen = 6)
    # The last step (print_words()) is not in the original problem,
    # but given that we usually process data further by passing
    # it to some other method, I decided to put post-processing
    # (in our case print_words()) of the data in a separate
    # method to simulate that.

    # Here I encapsulated my methods with a timer just to be
    # able to compare the speed between the different solutions.
    k = nil
    Timer.timer_msg("init_vars()") { k = self.new(maxlen) }
    Timer.timer_msg("load_dict()") { k.load_dict() }
    Timer.timer_msg("combine_all()") { k.combine_all() }
    Timer.timer_msg("print_words()") { k.print_words() }
  end

  def initialize(maxlen)
    @maxlen = maxlen
    @wordhash = {}
    (1...@maxlen).each do |i|
      @wordhash[i] = []
    end
    @targetwords = {}
  end

  def load_dict()
    File.open("wordlist.txt") do |f|
      f.readlines.each do |line|
        line.strip!
        line.downcase!
        if line.size == @maxlen
          @targetwords[line] = []
        elsif line.size < @maxlen
          @wordhash[line.size] << line
        end
      end
    end
  end

  def combine_all
    (1...@maxlen).each do |i|
      w1list = @wordhash[i]
      w2list = @wordhash[@maxlen-i]
      combine(w1list, w2list)
    end
  end

  def combine(w1list, w2list)
    w1list.each do |w1|
      w2list.each do |w2|
        wcat = w1+w2
        if @targetwords.include?(wcat)
          @targetwords[wcat] << [w1, w2]
        end
      end
    end
  end

  def print_words
    i = 0
    File.open("output.txt", "w") do |f|
      @targetwords.each do |w, l|
        l.each do |w1, w2|
          i += 1
          f.puts "#{w1} + #{w2} => #{w}"
        end
      end
    end
    puts "Number of combinations found: #{i}"
  end

end

def waiting_prompt()
  puts "All done - press any key to end"
  gets
end

if __FILE__ == $0
#  Just so I can compare it to my other solutions, I added
#  timers and I ran the process 3 times rather than 1 to
#  make sure the recorded times are accurate.
  3.times do
    Timer.timer_msg("Kata8a - Execution time") do
      Kata8a.runner(6)
    end
    puts ""
  end
  Timer.report
  waiting_prompt()
end

# Executing this on my Windows machine at home produced
# the following:

#init_vars(): 0.0 msecs
#load_dict(): 68.006 msecs
#combine_all(): 436.044 msecs
#Number of combinations found: 1536
#print_words(): 11.001 msecs
#Kata8a - Execution time: 515.051 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 74.008 msecs
#combine_all(): 464.046 msecs
#Number of combinations found: 1536
#print_words(): 11.001 msecs
#Kata8a - Execution time: 549.055 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 81.008 msecs
#combine_all(): 474.048 msecs
#Number of combinations found: 1536
#print_words(): 10.001 msecs
#Kata8a - Execution time: 565.057 msecs
#
#init_vars(): avg: 0.0 msecs (n: 3)
#load_dict(): avg: 74.3406666666667 msecs (n: 3)
#combine_all(): avg: 458.046 msecs (n: 3)
#print_words(): avg: 10.6676666666667 msecs (n: 3)
#Kata8a - Execution time: avg: 543.054333333333 msecs (n: 3)
