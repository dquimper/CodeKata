require 'kata8b'

# I should probably stop here at Kata8b.
# My final answer Kata8b is fast and readable (most readable
# if I were to move initialize() and runner() back into Kata8b)

# Just to play with the speed component further, I thought about
# using threads to take advantage of my 2 CPUs. But this solution
# turned out to be slower in this situation because the dictionary
# is too small and initiating threads is too heavy to make an
# improvement.

NBR_CPU = 2
class Kata8c < Kata8b

  def combine_all
    thrs = []
    Thread.abort_on_exception = true
    stepsize = @maxlen/NBR_CPU
    (1...@maxlen).step(stepsize) do |step|
      thrs << Thread.new do
        maxstep = step+stepsize
        maxstep = @maxlen if maxstep > @maxlen
        (step...maxstep).each do |i|
          w1list = @wordhash[i]
          w2list = @wordhash[@maxlen-i]
          if not (w1list.empty? and w2list.empty?)
            combine(w1list, w2list)
          end
        end
      end
    end
    thrs.each do |t|
      t.join
    end
  end

end

if __FILE__ == $0
  3.times do
    Timer.timer_msg("Kata8c - Execution time") do
      Kata8c.runner(8)
    end
    puts ""
  end
  Timer.report
  waiting_prompt()
end

# Executing this on my Windows machine at home produced
# the following:

#init_vars(): 0.0 msecs
#load_dict(): 66.0 msecs
#combine_all(): 444.0 msecs
#Number of combinations found: 1536
#print_words(): 9.0 msecs
#Kata8c - Execution time: 519.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 72.0 msecs
#combine_all(): 453.0 msecs
#Number of combinations found: 1536
#print_words(): 9.0 msecs
#Kata8c - Execution time: 535.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 73.0 msecs
#combine_all(): 452.0 msecs
#Number of combinations found: 1536
#print_words(): 9.0 msecs
#Kata8c - Execution time: 535.0 msecs
#
#combine_all(): avg: 449.666666666667 msecs (n: 3)
#Kata8c - Execution time: avg: 529.666666666667 msecs (n: 3)
#load_dict(): avg: 70.3333333333333 msecs (n: 3)
#print_words(): avg: 9.0 msecs (n: 3)
#init_vars(): avg: 0.0 msecs (n: 3)
#All done - press any key to end




# I was curious to see how fast my implementation would be when
# not limited to 6 characters. Increasing the number of characters
# produces a bigger numbers of combinations. I was hoping that the
# heavier workload would compensate the heaviness of starting 2
# threads.
#
# So I did the last part of the exercice and extended the code
# to accept a character limit. I introduced the maxlen parameter
# in the code. It doesn't complexify Kata8a much, so I left it there.
# Since ruby is an interpreted language, Kata8b is not slower with it.
# If this code was written in C, it would be different.

# Using Kata8b with 8 characters limit produced:

#init_vars(): 0.0 msecs
#load_dict(): 74.0 msecs
#combine_all(): 8188.0 msecs
#Number of combinations found: 2439
#print_words(): 12.0 msecs
#Kata8b - Execution time: 8276.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 80.0 msecs
#combine_all(): 7957.0 msecs
#Number of combinations found: 2439
#print_words(): 12.0 msecs
#Kata8b - Execution time: 8049.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 91.0 msecs
#combine_all(): 8206.0 msecs
#Number of combinations found: 2439
#print_words(): 12.0 msecs
#Kata8b - Execution time: 8309.0 msecs
#
#combine_all(): avg: 8117.0 msecs (n: 3)
#Kata8b - Execution time: avg: 8211.33333333333 msecs (n: 3)
#load_dict(): avg: 81.6666666666667 msecs (n: 3)
#print_words(): avg: 12.0 msecs (n: 3)
#init_vars(): avg: 0.0 msecs (n: 3)
#All done - press any key to end



# Using Kata8c with 8 characters limit produced:

#init_vars(): 1.0 msecs
#load_dict(): 77.0 msecs
#combine_all(): 9096.0 msecs
#Number of combinations found: 2439
#print_words(): 13.0 msecs
#Kata8c - Execution time: 9187.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 81.0 msecs
#combine_all(): 9286.0 msecs
#Number of combinations found: 2439
#print_words(): 20.0 msecs
#Kata8c - Execution time: 9388.0 msecs
#
#init_vars(): 0.0 msecs
#load_dict(): 76.0 msecs
#combine_all(): 9397.0 msecs
#Number of combinations found: 2439
#print_words(): 11.0 msecs
#Kata8c - Execution time: 9486.0 msecs
#
#combine_all(): avg: 9259.66666666667 msecs (n: 3)
#Kata8c - Execution time: avg: 9353.66666666667 msecs (n: 3)
#load_dict(): avg: 78.0 msecs (n: 3)
#print_words(): avg: 14.6666666666667 msecs (n: 3)
#init_vars(): avg: 0.333333333333333 msecs (n: 3)
#All done - press any key to end


# The introduction of threads was so heavy that the resulting code is slower.
# Possible cause: The Windows implementation of threads is pretty bad and
# the code is always interupted by other processes. Context switching is
# killing performance.

