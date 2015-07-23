class ExpensePresenter < BasePresenter
  def description
    @object.description
  end

  def expiration_date
    @object.expiration_date
  end

  def value
    @object.value
  end

  def paid?
    return "Yes" if @object.paid
    "No"
  end

  def expenses
     @object
  end
end
