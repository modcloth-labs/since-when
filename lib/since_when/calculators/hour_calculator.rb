require File.join(File.expand_path(File.dirname(__FILE__)), 'calculator')

module SinceWhen
  module Calculators
    class HourCalculator < Calculator

      def initalize(last_run)
        super(last_run)
        @interval_amt = 3600
      end

      private

      def increment(time)
        start_of_interval(time + 3600)
      end

      def start_of_interval(time)
        Time.utc(time.year, time.month, time.day, time.hour)
      end
    end
  end
end
