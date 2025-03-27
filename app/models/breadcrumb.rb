# frozen_string_literal: true

class Breadcrumb
  Step = Data.define(:title, :url) do
    def title?
      title.present?
    end

    def url?
      url.present?
    end
  end

  attr_reader :root_step, :steps

  def initialize(title = nil, url = nil)
    root(title, url) if title.present?

    @steps = []

    yield(self) if block_given?
  end

  def root(title = nil, url = nil)
    if block_given?
      url = title
      title = yield
    end

    @root_step = Step.new(title, url)

    self
  end

  def add(title = nil, url = nil)
    if block_given?
      url = title
      title = yield
    end

    @steps << Step.new(title, url)

    self
  end

  def each_steps(&)
    @steps.each(&)
  end

  def last
    @steps.last
  end

  def to_title(with_root: true)
    steps = @steps.reverse
    steps << @root_step if with_root

    steps.flatten.compact.filter_map(&:title).join(" | ")
  end
  alias to_s to_title
end
