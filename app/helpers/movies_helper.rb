module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def helper_class(type_help)
    if (params[:sort].to_s == type_help)
      return 'hilite'
    else
      return nil
    end
  end
    
      
  
end
