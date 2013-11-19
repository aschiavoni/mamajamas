class ListPruner
  def self.prune!(list)
    self.new(list).prune!
  end

  def initialize(list)
    @list = list
  end

  def prune!
    # do nothing for now
  end

  private

  def list
    @list
  end
end
