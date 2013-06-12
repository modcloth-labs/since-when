module SinceWhen
  module Calculators
    class HourCalculator

      def initialize(last_run)
        @last_run = last_run
        @default = start_of_hour(Time.now.utc)
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

      attr_reader :last_run, :default

      def equals?(left, right)
        start_of_hour(left) == start_of_hour(right)
      end

      def upto(first, last)
        t1, t2 = start_of_hour(first), start_of_hour(last)

        [].tap do |hours|
          while t1 <= t2 do
            hours << t1
            t1 = start_of_hour(t1 + 3600)
          end
        end
      end

      def start_of_hour(time)
        Time.utc(time.year, time.month, time.day, time.hour)
      end
    end
  end
end
