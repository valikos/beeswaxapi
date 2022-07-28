module BeeswaxAPI
  class Response < Dry::Struct
    attr_accessor :expection

    attribute :success?, Types::Bool
    attribute :message?, Types::String.optional
    attribute :errors?,  Types::Array.of(Types::String).optional
    attribute :payload?, Types::Array.of(Types::Hash) | Types::Hash
  end
end
