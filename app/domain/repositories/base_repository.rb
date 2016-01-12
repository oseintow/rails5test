require 'uri'

module Domain
  module Repositories
    class BaseRepository
      attr_accessor :model, :request, :fields, :model_schema
      attr_accessor :limit, :page, :exclude_from_query, :query_value_seperator

      def initialize(model)
        @associations = {}
        @limit = 0
        @page = 0
        @fields = []
        @exclude_from_query = []
        @query_value_seperator = "|"
        model(model)
      end

      def model(model)
        @model = model
        @model_schema = model
        @model_table_name = @model_schema.table_name
        @arel_table_schema = @model_schema.arel_table
        self
      end

      def request(request)
        @request = request
        @request_format = request.headers["Content-Type"] || request.params[:format]
        @request_format = (@request_format == "application/json" || @request_format =="json") ? "json" : request.headers["Content-Type"]
        @exclude_params = request.params.except(:action, :controller, :format)
        build_query()
        self
      end

      def build_query
        @exclude_params.each do |key, value|
          if BaseRepository.method_defined?(key)
            get_table_columns()
            required_methods = method(key).parameters.find_all { |arg| arg[0] == :req }
            if required_methods.count == 1 then
              method(key).call(value)
            else
              method(key).call(key, value)
            end
          else
            unless @exclude_from_query.include?(key)
              get_table_columns()
              if @fields.include? key then
                where(key, value)
              else
                method_missing(key, value)
              end
            end
          end
        end

        self
      end

      def get_table_columns
        if @fields.empty? && @model_schema
          @fields = @model_schema.column_names
        end
      end

      def method_missing(key, arg)
        if @fields.include? key[9..-1] # or_where_ from query string
          method(:or_where).call(key[9..-1], arg)
        end
      end

      def page(value)
        @page = value.to_i
      end

      def limit(value)
        @limit = value.to_i
      end

      def per_page(value)
        @limit = value.to_i
      end

      def build_includes(value)
        value.gsub! ".", ".include."
        value = value.split(".")
        association = value.reverse.inject { |a, n| {n.to_sym => a} }
        if association.is_a?(String) then
          @associations.merge!(association.to_sym => {})
        else
          @associations.merge!(association)
        end
      end

      def with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(".")
          associations = args.reverse.inject { |a, n| {n => a} }
          build_includes(val)
          @model = @model.includes(associations)
        end
        self
      end

      def with_is(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 3
            assc = args[0].split(".")
            associations = assc.reverse.inject { |a, n| {n => a} }
            build_includes(args[0])
            table_name = assc[-1].classify.singularize
            if Object.const_defined?(table_name) then
              table_name = table_name.constantize.arel_table
              @model = @model.eager_load(associations).where(table_name[args[1]].eq(args[2]))
            else

            end
          end
        end
        self
      end

      def with_contains(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 3
            assc = args[0].split(".")
            associations = assc.reverse.inject { |a, n| {n => a} }
            build_includes(args[0])
            table_name = assc[-1].classify.singularize
            if Object.const_defined?(table_name) then
              table_name = table_name.constantize.arel_table
              @model = @model.eager_load(associations).where(table_name[args[1]].matches("%#{args[2]}%"))
            end
          end
        end
        self
      end

      def with_start_with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 3
            assc = args[0].split(".")
            associations = assc.reverse.inject { |a, n| {n => a} }
            build_includes(args[0])
            table_name = assc[-1].classify.singularize
            if Object.const_defined?(table_name) then
              table_name = table_name.constantize.arel_table
              @model = @model.eager_load(associations).where(table_name[args[1]].matches("#{args[2]}%"))
            end
          end
        end
        self
      end

      def with_end_with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 3
            assc = args[0].split(".")
            associations = assc.reverse.inject { |a, n| {n => a} }
            build_includes(args[0])
            table_name = assc[-1].classify.singularize
            if Object.const_defined?(table_name) then
              table_name = table_name.constantize.arel_table
              @model = @model.eager_load(associations).where(table_name[args[1]].matches("%#{args[2]}"))
            end
          end
        end
        self
      end

      def contains(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 2 && @fields.include?(args[0])
            @model = @model.where(@arel_table_schema[args[0]].matches("%#{args[1]}%"))
          end
        end
        self
      end

      def or_contains(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 2 && @fields.include?(args[0])
            @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("%#{args[1]}%")))
          end
        end
        self
      end

      def start_with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 2 && @fields.include?(args[0])
            @model = @model.where(@arel_table_schema[args[0]].matches("#{args[1]}%"))
          end
        end
        self
      end

      def or_start_with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 2 && @fields.include?(args[0])
            @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("#{args[1]}%")))
          end
        end
        self
      end

      def end_with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 2 && @fields.include?(args[0])
            @model = @model.where(@arel_table_schema[args[0]].matches("%#{args[1]}"))
          end
        end
        self
      end

      def or_end_with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(",")
          if args.count == 2 && @fields.include?(args[0])
            @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("%#{args[1]}")))
          end
        end
        self
      end

      def or_where(key, value)
        # @model = @model.or(@model_schema.where("#{@model_table_name}.? = ?",key, arg))
        @model = @model.or(@model_schema.where(@arel_table_schema[key].eq(value)))
        self
      end

      def where(*args)
        # @model = @model.where("#{@model_table_name}.? = ?",args[0], args[1])
        @model = @model.where(@arel_table_schema[args[0]].eq(args[1]))
        self
      end

      def fields(value)
        value = value.split(",").each{|val| "#{@model_table_name}.#{val}" unless val.include?(".") }
        pri_key = "#{@model_table_name}.#{@model_schema.primary_key}"

        unless value.include?(pri_key)
          value << pri_key
        end
        value.join(",")
        @model = @model.select(value)
        self
      end

      def pluck(*args)
        @model.pluck(args.join(','))
      end

      def get
        if @page >= 1
          @collection = @model.page(@page).per(@limit) # kaminari
          # @model.paginate(:page => @page, :per_page => @limit) # will_paginate
        else
          @collection = @model.all
        end

        if @request_format == "json" then self else @collection end
      end

      def as_json(opts = {})
        make_json(opts)
      end

      def to_json(opts = {})
        make_json(opts)
      end

      def make_json(opts = {})
        if opts.empty? then
          opts = {:include => @associations}
        else
          options = opts[:include].is_a?(Symbol) ? {opts[:include] => {}} : opts[:include]
          opts = {:include => @associations.merge(options)}
        end

        build_data(opts)

      end

      def build_data(opts = {})
        if @page >= 1
          {
            :total => @collection.total_count,
            :per_page => @collection.limit_value,
            :current_page => @collection.current_page,
            :last_page => @collection.num_pages,
            :next_page_url => (@collection.current_page.to_i < @collection.num_pages) ? @request.base_url + @request.path + "?page=" +
                (@collection.current_page.to_i + 1).to_s + "&" + URI.decode(@exclude_params.except(:page).to_query) : nil,
            :prev_page_url => (@collection.current_page.to_i - 1 > 0 && !@collection.empty?) ? @request.base_url + @request.path + "?page=" +
                (@collection.current_page.to_i - 1).to_s + "&" + URI.decode(@exclude_params.except(:page).to_query) : nil,
            :from => !@collection.empty? ? (@collection.current_page - 1) * @collection.limit_value + 1 : 1,
            :to => !@collection.empty? ? ((@collection.current_page - 1) * @collection.limit_value + 1) + @collection.count - 1 : 0,
            :data => @collection.to_a.as_json(opts)
          }
        else
          @collection.to_a.as_json(opts)
        end
      end

    end
  end
end