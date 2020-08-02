# lib/rspec/sleeping_king_studios/matchers/core/delegate_method_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'

require 'sleeping_king_studios/tools/array_tools'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object delegates a method to the specified
  # other object.
  #
  # @since 2.2.0
  class DelegateMethodMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::Mocks::ExampleMethods

    # @api private
    DEFAULT_EXPECTED_RETURN = Object.new.freeze

    # @param expected [Array<String, Symbol>] The names of the methods that
    #   should be delegated to the target.
    def initialize expected
      @expected               = expected
      @expected_arguments     = []
      @expected_keywords      = {}
      @expected_block         = false
      @received_block         = false
      @expected_return_values = []
      @received_return_values = []
      @errors                 = {}
    end # method initialize

    attr_reader :expected
    alias_method :method_name, :expected

    # Specifies that the actual method, when called, will return the specified
    # value. If more than one return value is specified, the method will be
    # called one time for each return value, and on the Nth call must return
    # the Nth specified return value.
    #
    # @param return_values [Array<Object>] The expected values to be returned
    # from calling the method on the actual object.
    #
    # @return [DelegateMethodMatcher] self
    def and_return *return_values
      @expected_return_values = return_values

      self
    end # method and_return

    # (see BaseMatcher#description)
    def description
      str = 'delegate method'
      str << " :#{@expected}" if @expected
      str << " to #{@target.inspect}" if @target
      str
    end # method description

    # (see BaseMatcher#failure_message)
    def failure_message
      message =
        "expected #{@actual.inspect} to delegate :#{@expected} to "\
        "#{@target.inspect}"

      if @errors.key?(:actual_does_not_respond_to)
        message << ", but #{@actual.inspect} does not respond to :#{@expected}"

        return message
      end # if

      if @errors.key?(:target_does_not_respond_to)
        message << ", but #{@target.inspect} does not respond to :#{@expected}"

        return message
      end # if

      if @errors.key?(:raised_exception)
        exception = @errors[:raised_exception]

        message << format_arguments << format_return_values <<
          ", but ##{@expected} raised #{exception.class.name}: "\
          "#{exception.message}"

        return message
      end # if

      if @errors.key?(:actual_does_not_delegate_to_target)
        message <<
          ", but calling ##{@expected} on the object does not call "\
          "##{@expected} on the delegate"

        return message
      end # if

      message << format_arguments << format_return_values

      if @errors.key?(:unexpected_arguments)
        message << ", but #{@errors[:unexpected_arguments]}"

        return message
      end # if

      if @errors.key?(:block_not_received)
        message << ', but the block was not passed to the delegate'

        return message
      end # if

      if @errors.key?(:unexpected_return)
        values = @errors[:unexpected_return].map &:inspect

        message << ', but returned ' <<
          SleepingKingStudios::Tools::ArrayTools.humanize_list(values)
      end # if

      message
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message =
        "expected #{@actual.inspect} not to delegate :#{@expected} to "\
        "#{@target.inspect}"

      message << format_arguments << format_return_values
    end # method failure_message_when_negated

    # (see BaseMatcher#matches?)
    def matches? actual
      super

      raise ArgumentError.new('must specify a target') if @target.nil?

      responds_to_method? && delegates_method?
    end # method matches?

    # Specifies the target object. The expected methods should be delegated
    # from the actual object to the target.
    #
    # @param target [Object] The target object.
    #
    # @return [DelegateMethodMatcher] self
    def to target
      @target = target

      self
    end # method to

    # Specifies that a block argument must be passed in to the target when
    # calling the method on the actual object.
    #
    # @return [DelegateMethodMatcher] self
    def with_a_block
      @expected_block = true

      self
    end # method with_a_block
    alias_method :and_a_block, :with_a_block

    # Specifies a list of arguments. The provided arguments are passed in to the
    # method call when calling the method on the actual object, and must be
    # passed on to the target.
    #
    # @param arguments [Array<Object>] The arguments to be passed in to the
    #   method and which must be forwarded to the target.
    #
    # @return [DelegateMethodMatcher] self
    def with_arguments *arguments
      @expected_arguments = arguments

      self
    end # method with_arguments
    alias_method :and_arguments, :with_arguments

    # Specifies a hash of keywords and values. The provided keywords are passed
    # in to the method call when calling the method on the actual object, and
    # must be passed on to the target.
    #
    # @param keywords [Hash] The keywords to be passed in to the
    #   method and which must be forwarded to the target.
    #
    # @return [DelegateMethodMatcher] self
    def with_keywords **keywords
      @expected_keywords = keywords

      self
    end # method with_keywords
    alias_method :and_keywords, :with_keywords

    private

    def call_method(arguments:, keywords:, expected_return: DEFAULT_EXPECTED_RETURN)
      if @expected_block
        @received_block = false
        block           = ->(*args, **kwargs, &block) {}

        if keywords.empty?
          return_value = @actual.send(@expected, *arguments, &block)
        else
          return_value = @actual.send(@expected, *arguments, **keywords, &block)
        end
      else
        if keywords.empty?
          return_value = @actual.send(@expected, *arguments)
        else
          return_value = @actual.send(@expected, *arguments, **keywords)
        end
      end

      @received_return_values << return_value

      if @expected_block && !@received_block
        @errors[:block_not_received] = true
      end # if

      return if expected_return == DEFAULT_EXPECTED_RETURN

      unless return_value == expected_return
        @errors[:unexpected_return] = @received_return_values
      end # unless
    rescue StandardError => exception
      @errors[:raised_exception] = exception
    end # method call_method

    def delegates_method?
      stub_target!

      if @expected_return_values.empty?
        call_method(arguments: @expected_arguments, keywords: @expected_keywords)
      else
        @expected_return_values.each do |return_value|
          call_method(arguments: @expected_arguments, keywords: @expected_keywords, expected_return: return_value)
        end # each
      end # if-else

      matcher = RSpec::Mocks::Matchers::HaveReceived.new(@expected)
      if !@expected_arguments.empty? && !@expected_keywords.empty?
        matcher = matcher.with(*@expected_arguments, **@expected_keywords)
      elsif !@expected_arguments.empty?
        matcher = matcher.with(*@expected_arguments)
      elsif !@expected_keywords.empty?
        matcher = matcher.with(**@expected_keywords)
      end

      unless @expected_return_values.empty?
        matcher = matcher.exactly(@expected_return_values.count).times
      end # unless

      unless matcher.matches? @target
        if matcher.failure_message =~ /with unexpected arguments/
          @errors[:unexpected_arguments] = matcher.failure_message
        else
          @errors[:actual_does_not_delegate_to_target] = true
        end # if
      end # unless

      @errors.empty?
    end # method delegates_method?

    def format_arguments
      fragments = []

      unless @expected_arguments.empty?
        args = SleepingKingStudios::Tools::ArrayTools.humanize_list(@expected_arguments.map &:inspect)

        fragments << ('arguments ' << args)
      end # unless

      unless @expected_keywords.empty?
        kwargs = @expected_keywords.map { |key, value| "#{key.inspect}=>#{value.inspect}" }
        kwargs = SleepingKingStudios::Tools::ArrayTools.humanize_list(kwargs)

        fragments << ('keywords ' << kwargs)
      end # unless

      if fragments.empty?
        arguments = ' with no arguments'
      else
        arguments = ' with ' << fragments.join(' and ')
      end # if-else

      arguments << ' and yield a block' if @expected_block

      arguments
    end # method format_arguments

    def format_return_values
      return '' if @expected_return_values.empty?

      values = @expected_return_values.map &:inspect

      ' and return ' << SleepingKingStudios::Tools::ArrayTools.humanize_list(values)
    end # method format_return_values

    def responds_to_method?
      unless @actual.respond_to?(@expected)
        @errors[:actual_does_not_respond_to] = true
      end # unless

      unless @target.respond_to?(@expected)
        @errors[:target_does_not_respond_to] = true
      end # unless

      @errors.empty?
    end # method responds_to_methods?

    def stub_target!
      original_method = @target.method(@expected)

      receive_matcher = receive(@expected)
      receive_matcher.with(any_args) do |*args, **kwargs, &block|
        @received_block = !!block

        if kwargs.empty?
          original_method.call(*args, &block)
        else
          original_method.call(*args, **kwargs, &block)
        end # if-else
      end # matcher

      allow(@target).to receive_matcher
    end # metod stub_target!
  end # class
end # module
