module Domain
  module Repositories
    class BaseRepository
      # attr_accessor :model, :request, :fields, :model_schema
      # attr_accessor :limit, :page, :exclude_from_query

      def initialize(model)
        @limit = 0
        @page = 0
        @fields = []
        @exclude_from_query = []
        model(model)
      end

      def model(model)
        @model = model
        @model_schema = model
        @model_table_name = @model_schema.to_s.underscore.pluralize
        @arel_table_schema = @model_schema.arel_table
        self
      end

      def request(request)
        @request = request.except(:action, :controller, :format)
        build_query()
        self
      end

      def build_query
        @request.each do |key,value|
          if BaseRepository.method_defined?(key)
            get_table_columns()
            required_methods = method(key).parameters.find_all { |arg| arg[0] == :req}
            if required_methods.count == 1 then method(key).call(value) else method(key).call(key,value) end
          else
            unless @exclude_from_query.include?(key)
              get_table_columns()
              if @fields.include? key then where(key,value) else method_missing(key,value) end
            end
          end
        end

        self
      end

      def get_table_columns
        if @fields.empty? and @model_schema
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

      def with(value)
        args = value.split(".")
        associations = args.reverse.inject { |a, n| { n => a } }
        @model = @model.includes(associations)
        self
      end

      def contains(value)
        args = value.split(',')
        if args.count == 2 and @fields.include?(args[0])
          @model = @model.where(@arel_table_schema[args[0]].matches("%#{args[1]}%"))
        end
        self
      end

      def or_contains(value)
        args = value.split(',')
        if args.count == 2 and @fields.include?(args[0])
          @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("%#{args[1]}%")))
        end
        self
      end

      def start_with(value)
        args = value.split(',')
        if args.count == 2 and @fields.include?(args[0])
            @model = @model.where(@arel_table_schema[args[0]].matches("#{args[1]}%"))
        end
        self
      end

      def or_start_with(value)
        args = value.split(',')
        if args.count == 2 and @fields.include?(args[0])
          @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("#{args[1]}%")))
        end
        self
      end

      def end_with(value)
        args = value.split(',')
        if args.count == 2 and @fields.include?(args[0])
          @model = @model.where(@arel_table_schema[args[0]].matches("%#{args[1]}"))
        end
        self
      end

      def or_end_with(value)
        args = value.split(',')
        if args.count == 2 and @fields.include?(args[0])
          @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("%#{args[1]}")))
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

      def pluck(*args)
        @model.pluck(args.join(','))
      end

      def get
        if @page >= 1
          @model.page(@page).per(@limit)
        else
          @model.all
        end
      end

    end
  end
end