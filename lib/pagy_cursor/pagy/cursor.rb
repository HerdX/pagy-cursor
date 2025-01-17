class Pagy

  class Cursor < Pagy
    attr_reader :before, :after, :arel_table, :primary_key, :order, :comparation, :position
    attr_accessor :has_more
    alias_method :has_more?, :has_more

    def initialize(vars)
      @vars = VARS.merge(vars.delete_if{|_,v| v.nil? || v == '' })
      @items = vars[:items] || VARS[:items]
      @before = vars[:before]
      @after = vars[:after]
      @arel_table = vars[:arel_table]
      @primary_key = vars[:primary_key]
      @sort_key = vars[:sort] || @primary_key
      if @before.present? and @after.present?
        raise(ArgumentError, 'before and after can not be both mentioned')
      end

      if vars[:backend] == 'uuid'

        @comparation = 'lt' # arel table less than
        @position = @before
        @order = { :created_at => :desc , @sort_key => :desc }

        if @after.present?
          @comparation = 'gt' # arel table greater than
          @position = @after
          @order = { :created_at => :asc , @sort_key => :asc }
        end
      else

        @comparation = 'lt'
        @position = @before
        @order = { @sort_key => :desc }

        if @after.present?
          @comparation = 'gt'
          @position = @after
          @order = { @sort_key => :asc }
        end
      end
    end
  end
 end
