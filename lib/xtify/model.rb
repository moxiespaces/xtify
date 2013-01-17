module Xtify
  module Model
    extend ActiveSupport::Concern

    included do
      def self.xtify_model(*fields)
        @fields = fields
        attr_accessor *fields
      end

      def self.one(assoc, opts={})
        @one_associations ||= {}
        @one_associations[assoc] = opts
        attr_accessor assoc
      end

      def self.fields
        @fields || []
      end

      def self.one_associations
        @one_associations ||= {}
      end
    end

    def fields
      self.class.fields
    end

    def one_associations
      self.class.one_associations
    end

    def initialize(opts={})
      opts = opts.symbolize_keys
      fields.each do |field|
        self.send("#{field}=", opts[field])
      end

      one_associations.each do |assoc, assoc_opts|
        value = opts[assoc]
        if value.is_a?(Hash)
          klass = assoc_opts[:type] || File.join("xtify", assoc.to_s).classify.constantize
          value = klass.new(value)
        end
        self.send("#{assoc}=", value)
      end
    end

    def as_json(opts={})
      json = {}
      (fields + one_associations.keys).each do |field|
        value = send(field)
        json[field] = value unless value.blank?
      end
      json
    end
  end
end