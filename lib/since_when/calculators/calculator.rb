module SinceWhen
  module Calculators
    class Calculator

      def initialize(last_run)
        @last_run = last_run
        @default = decrement(Time.now.utc)
      end

      def find
        if last_run.nil?
          [default]
        elsif equals?(last_run, default)
          []
        else
          upto(last_run, default)
        end
      end

      private

      attr_reader :last_run, :default, :interval_amt

      def equals?(left, right)
        start_of_interval(left) == start_of_interval(right)
      end

      def increment(time)
        start_of_interval(time + interval_amt)
      end

      def decrement(time)
        start_of_interval(time - interval_amt)
      end

      def upto(first, last)
        t1 = increment(first)
        t2 = start_of_interval(last)

        [].tap do |times|
          while t1 <= t2 do
            times << t1
            t1 = increment(t1)
          end
        end
      end
    end
  end
end
