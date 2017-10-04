module StubChainMocha
  module Object
    # Source: http://blog.leshill.org/blog/2009/08/05/update-for-stub-chain-for-mocha.html
    def stub_chain(*methods)
      if methods.length > 1
        next_in_chain = ::Object.new
        stubs(methods.shift).returns(next_in_chain)
        next_in_chain.stub_chain(*methods)
      elsif methods[0] == :select
        stubs(methods.shift)
      end
    end

    def expect_chain(*methods)
      if methods.length > 1
        next_in_chain = ::Object.new
        expects(methods.shift).returns(next_in_chain)
        next_in_chain.expect_chain(*methods)
      else
        expects(methods.shift)
      end
    end

    def not_expect_chain(*methods)
      if methods.length > 1
        next_in_chain = ::Object.new
        stubs(methods.shift).returns(next_in_chain)
        next_in_chain.not_expect_chain(*methods)
      else
        expects(methods.shift).never
      end
    end

    def stub_private(method_name, options = {})
      next_return_value = options[:returns]
      returns(PRIVATE_MOCKS[method_name].new(next_return_value))
    end
  end

  # Hack for stubbing "select", which is a private Object method.
  # Must be last in chain.
  class Selectable
    def initialize return_value
      @return_value = return_value
    end

    def select(*)
      @return_value
    end
  end

  PRIVATE_MOCKS = { select: Selectable }.freeze
end

Object.send(:include, StubChainMocha::Object)
