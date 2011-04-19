class Timer

  @@msgs = {}

  def self.timer_msg(msg, &block)
    t1 = Time.now
    yield
    t = Time.now - t1
    @@msgs[msg] = [] if @@msgs[msg].nil?
    @@msgs[msg] << t*1000
    puts msg + ": #{t*1000} msecs"
    return t
  end

  def self.report
    @@msgs.each do |m, tlst|
      n = tlst.size
      avg = 0
      tlst.each {|i| avg += i}
      avg /= n
      puts m + ": avg: #{avg} msecs (n: #{n})"
    end
  end
end

