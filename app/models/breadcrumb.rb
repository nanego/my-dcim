# frozen_string_literal: true

class Breadcrumb
  Step = Data.define(:title, :url)

  def initialize
    @steps = []
  end

  # Usefull?
  # def root(title, url:)
  # end

  def add(title, url = nil)
    title = yield if block_given?

    @steps << Step.new(title, url)
  end

  def each_steps(&)
    @steps.each(&)
  end

  def to_s
    @steps.filter_map(&:title).join(" | ")
  end
end
