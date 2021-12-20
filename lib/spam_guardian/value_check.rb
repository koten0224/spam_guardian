require 'active_support'
require 'active_support/core_ext'
module SpamGuardian
  class ValueCheck
    attr_reader :klass
    def initialize(klass)
      raise FormatError("'#{klass}';Should be a class.") unless klass.is_a?(Class)
      @klass = klass
    end

    def sub_class(klass)
      raise FormatError("'#{klass}';Should be a class.") unless klass.is_a?(Class)
      dup.tap do |checker|
        checker.instance_eval do
          if @sub_checker.is_a?(ValueCheck)
            @sub_checker = @sub_checker.sub_class(klass)
          else
            @sub_checker = ValueCheck.new(klass)
          end
        end
      end
    end

    def check(value)
      return false unless value.is_a?(klass)
      case value
      when Array, Hash
        return true unless @sub_checker.is_a?(ValueCheck)
        value.all? do |(*args)|
          @sub_checker.check(args.last)
        end
      else
        true
      end
    end
  end
end
