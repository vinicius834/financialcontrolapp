module CurrencyHelper
  include ActionView::Helpers::NumberHelper
  
  def to_currency(number)
    number_to_currency(number, separator: ",", delimiter: ".", negative_format: "%u%n")
  end
  
end