# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to.rb

module RSpec::Matchers::BuiltIn
  class RespondTo
    def find_failing_method_names(actual, filter_method)
      @actual = actual
      @failing_method_reasons = {}
      @failing_method_names   = @names.__send__(filter_method) do |name|
        @actual.respond_to?(name) &&
          matches_arity?(actual, name) &&
          matches_keywords?(actual, name) &&
          matches_block?(actual, name)
      end # send
    end # method find_failing_method_names
    
    def matches_arity?(actual, name)
      return true unless @expected_arity
      
      parameters = actual.method(name).parameters
      required   = parameters.count { |type, | :req  == type }
      optional   = parameters.count { |type, | :opt  == type }
      variadic   = parameters.count { |type, | :rest == type }

      min, max = @expected_arity.is_a?(Range) ?
        [@expected_arity.begin, @expected_arity.end] :
        [@expected_arity,       @expected_arity]

      if min < required
        (@failing_method_reasons[name] ||= {})[:not_enough_args] = { arity: min, count: required }
        return false
      elsif 0 == variadic && max > required + optional
        (@failing_method_reasons[name] ||= {})[:too_many_args]   = { arity: max, count: required + optional }
        return false
      end # if

      true
    end # method matches_arity?

    def matches_keywords?(actual, name)
      return true unless ruby_version >= "2.0.0"
      return true unless @expected_keywords

      parameters = actual.method(name).parameters
      return true if 0 < parameters.count { |type, _| :keyrest == type }

      mismatch = []
      @expected_keywords.each do |keyword|
        mismatch << keyword unless parameters.include?([:key, keyword])
      end # each

      if mismatch.empty?
        true
      else
        (@failing_method_reasons[name] ||= {})[:unexpected_keywords] = mismatch
        false
      end # if-else
    end # method matches_keywords?
    
    def matches_block?(actual, name)
      return true unless @expected_block

      parameters = actual.method(name).parameters
      if 0 < parameters.count { |type, | :block == type }
        true
      else
        (@failing_method_reasons[name] ||= {})[:expected_block] = true
        false
      end # if-else
    end # method matches_block?

    def failure_message_for_should
      messages = []
      @failing_method_names.map do |method|
        message = "expected #{@actual.inspect} to respond to #{method.inspect}"
        if @actual.respond_to?(method)
          message << " with arguments:\n#{format_errors_for_method method}"
        end # if-else
        messages << message
      end # method
      messages.join "\n"
    end # method failure_message_for_should_not
    
    def failure_message_for_should_not
      methods, messages = @names - @failing_method_names, []

      @names.map do |method|
        message   = "expected #{@actual.inspect} not to respond to #{method.inspect}"
        unless (formatted = format_expected_arguments).empty?
          message << " with #{formatted}"
        end # unless
        messages << message
      end # method
      messages.join "\n"
    end # method failure_message_for_should_not
    
    def with(n = nil, *keywords)
      @expected_arity    = n unless n.nil?
      @expected_keywords = keywords
      self
    end # method with
    
    def and
      self
    end # method and
    
    def a_block
      @expected_block = true
      self
    end # method a_block

  private
    def ruby_version
      RSpec::SleepingKingStudios::Util::Version.new ::RUBY_VERSION
    end # method ruby_version

    def format_expected_arguments
      messages = []
      
      if !@expected_arity.nil?
        messages << "#{@expected_arity.inspect} argument#{1 == @expected_arity ? "" : "s"}"
      end # if

      if !(@expected_keywords.nil? || @expected_keywords.empty?)
        messages << "keywords #{@expected_keywords.map(&:inspect).join(", ")}"
      end # if

      if @expected_block
        messages << "a block"
      end # if

      case messages.count
      when 0..1
        messages.join(", ")
      when 2
        "#{messages[0]} and #{messages[1]}"
      else
        "#{messages[1..-1].join(", ")}, and #{messages[0]}"
      end # case
    end # method format_expected_arguments

    def format_errors_for_method method
      reasons, messages = @failing_method_reasons[method], []
      
      if hsh = reasons.fetch(:not_enough_args, false)
        messages << "  expected at least #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      elsif hsh = reasons.fetch(:too_many_args, false)
        messages << "  expected at most #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      end # if-elsif

      if ary = reasons.fetch(:unexpected_keywords, false)
        messages << "  unexpected keywords #{ary.map(&:inspect).join(", ")}"
      end # if

      if reasons.fetch(:expected_block, false)
        messages << "  unexpected block"
      end # if

      messages.join "\n"
    end # method format_errors_for_method      
  end # class RespondTo
end # module
