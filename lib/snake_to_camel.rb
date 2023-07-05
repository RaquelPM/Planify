require 'multi_json'

module SnakeToCamel
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)

      request.params&.each do |key, value|
        request.delete_param(key)
        request.update_param(key.underscore, to_snake_case(value))
      end

      status, headers, response = @app.call(env)

      new_response = []

      response&.each do |value|
        object = MultiJson.load(value)

        object = to_camel_case(object)

        new_response.push MultiJson.dump(object)
      rescue MultiJson::ParseError
        new_response.push(value)
      end

      headers['Content-Length'] = new_response.sum(&:bytesize).to_s

      [status, headers, new_response]
    end

    def to_snake_case(object)
      case object
      when Array then object.map { |e| to_snake_case(e) }
      when Hash then object.deep_transform_keys(&:underscore)
      else object
      end
    end

    def to_camel_case(object)
      case object
      when Array then object.map { |e| to_camel_case(e) }
      when Hash then object.deep_transform_keys { |k| k.camelize(:lower) }
      else object
      end
    end
  end
end
