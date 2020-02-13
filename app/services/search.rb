class Services::Search
  TYPES = %w[All Questions Answers Comments Users].freeze

  attr_reader :type, :query

  def initialize(type, query)
    @type = type
    @query = query
  end

  def search
    klass.search query
  end

  private

  def klass
    type == 'All' ? ThinkingSphinx : type.singularize.constantize
  end
end
