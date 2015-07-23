class BasePresenter < SimpleDelegator
  def initialize(object, view)
    @object = object
    @view = view
  end

  def h
    @view
  end
end
