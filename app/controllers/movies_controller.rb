class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  
  
  

  def index

    if params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end

    @sort_values = params[:sort]
    @ratings_values = params[:ratings] 
    if @ratings_values.nil?
      ratings_values = Movie.ratings 
    else
      ratings_values = @ratings_values.keys
    end

    @all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
          all_ratings[rating] = @ratings_values.nil? ? false : @ratings_values.has_key?(rating) 
          all_ratings
      end
      
    if !@sort_values.nil?
        @movies = Movie.order("#{@sort_values} ASC").where(rating: ratings_values)
    else
      @movies = Movie.where(rating: ratings_values)
    end

    session[:sort] = @sort_values
    session[:ratings] = @ratings_values
  end


  

  # def index
  #   @all_ratings = ['G', 'PG', 'PG-13', 'R']
  #   @selected_ratings = (params[:ratings].present? ? params[:ratings] : [])
    
    
  #   ratings_dict =  params['ratings']

  #   if params.length == 0
  #     @movies = Movie.all()
  #   elsif (!ratings_dict.nil?)
  #     @movies = Movie.where(rating: ratings_dict.keys)
  #   else
  #     @movies = Movie.order(params[:sort])
  #   end
  # end

  def new
    # default: render 'new' template
  end

  def create
    
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end
  
  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
