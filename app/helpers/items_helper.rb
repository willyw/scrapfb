module ItemsHelper
  def render_categories( categories ) 
    string = ""
    base = categories.first.to_date.ld
    for category in categories
      string << "'#{category.to_date.ld - base}',"
    end
    a = string.gsub(/,$/, '')
    return a
  end
  
  def render_data( datas )
    string = ""
    for data in datas
      string << "#{data},"
    end
    a = string.gsub(/,$/, '')
    return a
  end
end
