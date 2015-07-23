class IncomePresenter < BasePresenter
  def description
    @object.description
  end

  def date
    @object.date
  end

  def value
    @object.value
  end

  def incomes
     @object
  end
end
