module Lita
  # Allows blocks of code to be executed after an interval or recurring at
  # regular intervals.
  class Timer
    def initialize
      @timers = Timers.new
      @thread = Thread.new { loop { @timers.wait } }
      @thread.abort_on_exception = true
    end

    # Invokes the given block after the given number of seconds.
    # @param delay [Integer] The number of seconds to wait before invoking the
    #   provided block.
    # @return [void]
    def after(delay, &block)
      @timers.after(delay, &block)
      self
    end

    # Invokes the given block repeatedly, waiting the given number of seconds
    #   between each invocation.
    # @param interval [Integer] The number of seconds to wait before each
    #   invocation of the block.
    # @return [void]
    def every(interval, &block)
      @timers.every(interval, &block)
      self
    end

    # Stops all running timers.
    # @return [void]
    def stop
      @timers.each { |timer| timer.cancel }
      @thread.kill
      self
    end
  end
end
