require_relative 'calculator'

module SinceWhen
  module Calculators
    class DayCalculator < Calculator

      def interval_amt
        3600 * 24
      end

      private

      def start_of_interval(time)
        Time.utc(time.year, time.month, time.day)
      end
    end
  end
end
