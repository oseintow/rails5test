module Domain
  module Repositories
    class BaseRepository
      attr_accessor :model, :request, :fields, :model_schema
      attr_accessor :limit, :page, :exclude_from_query, :query_value_seperator

      def initialize(model)
        $associations = {}
        @limit  = 0
        @page   = 0
        @fields = []
        @exclude_from_query = []
        @query_value_seperator = "|"
        model(model)
      end

      def model(model)
        @model = model
        @model_schema = model
        # @model_table_name = @model_schema.to_s.underscore.pluralize
        @model_table_name  = @model_schema.table_name
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
        value.gsub! ".",".include."
        value = value.split(".")
        association = value.reverse.inject { |a, n| { n.to_sym => a} }
        if association.is_a?(String) then $associations.merge!(association.to_sym => {}) else $associations.merge!(association) end
      end

      def with(value)
        value = value.split(@query_value_seperator)
        value.each do |val|
          args = val.split(".")
          associations = args.reverse.inject { |a, n| { n => a } }
          build_includes(val)
          @model = @model.includes(associations)
        end
        self
      end

      def with_is(value)
        args = value.split(",")
        if args.count == 3
          assc = args[0].split(".")
          associations = assc.reverse.inject { |a, n| { n => a } }
          build_includes(args[0])
          table_name = assc[-1].classify.singularize
          if Object.const_defined?(table_name) then
            table_name = table_name.constantize.arel_table
            @model = @model.eager_load(associations).where(table_name[args[1]].eq(args[2]))
          else

          end
        end
        self
      end

      def with_contains(value)
        args = value.split(",")
        if args.count == 3
          assc = args[0].split(".")
          associations = assc.reverse.inject { |a, n| { n => a } }
          build_includes(args[0])
          table_name = assc[-1].classify.singularize
          if Object.const_defined?(table_name) then
            table_name = table_name.constantize.arel_table
            @model = @model.eager_load(associations).where(table_name[args[1]].matches("%#{args[2]}%"))
          end
        end
        self
      end

      def with_start_with(value)
        args = value.split(",")
        if args.count == 3
          assc = args[0].split(".")
          associations = assc.reverse.inject { |a, n| { n => a } }
          build_includes(args[0])
          table_name = assc[-1].classify.singularize
          if Object.const_defined?(table_name) then
            table_name = table_name.constantize.arel_table
            @model = @model.eager_load(associations).where(table_name[args[1]].matches("#{args[2]}%"))
          end
        end
        self
      end

      def with_end_with(value)
        args = value.split(",")
        if args.count == 3
          assc = args[0].split(".")
          associations = assc.reverse.inject { |a, n| { n => a } }
          build_includes(args[0])
          table_name = assc[-1].classify.singularize
          if Object.const_defined?(table_name) then
            table_name = table_name.constantize.arel_table
            @model = @model.eager_load(associations).where(table_name[args[1]].matches("%#{args[2]}"))
          end
        end
        self
      end

      def contains(value)
        args = value.split(',')
        if args.count == 2 && @fields.include?(args[0])
          @model = @model.where(@arel_table_schema[args[0]].matches("%#{args[1]}%"))
        end
        self
      end

      def or_contains(value)
        args = value.split(',')
        if args.count == 2 && @fields.include?(args[0])
          @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("%#{args[1]}%")))
        end
        self
      end

      def start_with(value)
        args = value.split(',')
        if args.count == 2 && @fields.include?(args[0])
            @model = @model.where(@arel_table_schema[args[0]].matches("#{args[1]}%"))
        end
        self
      end

      def or_start_with(value)
        args = value.split(',')
        if args.count == 2 && @fields.include?(args[0])
          @model = @model.or(@model_schema.where(@arel_table_schema[args[0]].matches("#{args[1]}%")))
        end
        self
      end

      def end_with(value)
        args = value.split(',')
        if args.count == 2 && @fields.include?(args[0])
          @model = @model.where(@arel_table_schema[args[0]].matches("%#{args[1]}"))
        end
        self
      end

      def or_end_with(value)
        args = value.split(',')
        if args.count == 2 && @fields.include?(args[0])
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

      def fields(value)
        if value.split(",").include?(@model_schema.primary_key)
          value = "#{@model_table_name}." + value
        else
          value = "#{@model_table_name}.#{@model_schema.primary_key}," + value
        end
        value.gsub! ",", ",#{@model_table_name}."
        @model = @model.select(value)
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