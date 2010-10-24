class SimpleJob < Struct.new(:id, :perform)
  def ===(other)
    self.id == other.id
  end
end
