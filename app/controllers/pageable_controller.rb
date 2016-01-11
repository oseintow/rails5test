class PageableController < ApplicationController
  def initialize (collection)
    @collection = collection
  end
  def as_json(opts = {})
    {
        :num_pages => @collection.num_pages,
        :limit_value => @collection.limit_value,
        :current_page => @collection.current_page,
        :total_count => @collection.total_count,
        :records => @collection.to_a.as_json(opts)
    }
  end
end