module BeeswaxAPI
  class Response < Dry::Struct
    constructor_type :schema

    attribute :success, Types::Bool
    attribute :message, Types::String.optional
    attribute :errors,  Types::Array.member(Types::String).optional
    attribute :payload, Types::Hash
  end
end
