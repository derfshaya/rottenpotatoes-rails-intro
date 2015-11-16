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
    # check session
    redirected = false
    unless params[:ratings].nil? || params[:ratings].empty?
      session[:ratings] = params[:ratings]
    else
      unless session[:ratings].nil?
        redirected = true
      end
    end
    unless params[:sort_by].nil?
      session[:sort_by] = params[:sort_by]
    else
      unless session[:sort_by].nil?
        redirected = true
      end
    end
    
    session = Hash.new
    
    unless redirected 
      @movies = Movie.all
      @ratings = params[:ratings].nil? ? [] : params[:ratings].keys
      unless @ratings.length == 0
        ratings_where_str = "`rating` IN (?" + ",?" * (@ratings.length - 1) + ")"
        @movies = @movies.where(@ratings.unshift(ratings_where_str))
      end
    
      if params[:sort_by] == "release_date"
        @movies = @movies.order(:release_date)
      elsif params[:sort_by] == "title"
        @movies = @movies.order(:title)
      end
      
      @all_ratings = Movie.all_ratings
    else
      redirect_to movies_path(ratings: session[:ratings].nil? ? params[:ratings] : session[:ratings], sort_by: session[:sort_by].nil? ? params[:sort_by] : session[:sort_by] )
    end
  end

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
