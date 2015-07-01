module UtilFunctions
  def date_range(from_date, to_date)
    from_date = Date.parse(from_date)
    to_date =  Date.parse(to_date)
    from_date..to_date
  end
end


