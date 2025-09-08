# frozen_string_literal: true

module RubyLLM
  module Providers
    class Bedrock
      # Embeddings methods of the AWS Bedrock Runtime API integration
      module Embeddings
        module_function

        def render_embedding_payload(text, model:, dimensions:)
          # Titan Text v1 does not support custom dimensions
          dimensions = nil if model.include?('amazon.titan-embed-text-v1')
          {
            inputText: text,
            dimensions: dimensions
          }.compact
        end

        def embedding_url(model:)
          "model/#{model}/invoke"
        end

        def parse_embedding_response(response, model:, text:) # rubocop:disable Lint/UnusedMethodArgument
          model_response = response.body
          input_tokens = model_response['inputTextTokenCount'] || 0
          vectors = model_response['embedding']

          Embedding.new(vectors:, model:, input_tokens:)
        end
      end
    end
  end
end
