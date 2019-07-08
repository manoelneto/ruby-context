require 'securerandom'

module Context
  class Context
    def initialize default_value: nil, key: SecureRandom.hex
      @default_value, @key = default_value, key
    end

    def method_missing(method, *args)
      get.send(method, *args)
    end

    def set value
      Thread.current[@key] = value
    end

    def with value, &block
      thread = Thread.current
      prev_value = thread[@key]

      begin
        thread[@key] = value
    
        yield
      ensure
        thread[@key] = prev_value
      end
    end

    def get
      if thread = thread_with_value_or_nil
        thread[@key]
      else
        @default_value
      end
    end

    def thread_with_value_or_nil
      thread = Thread.current
  
      while not thread.key?(@key) and thread.parent
        thread = thread.parent
      end
  
      thread.key?(@key) ? thread : nil
    end
  end
end