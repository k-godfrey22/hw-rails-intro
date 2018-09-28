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
    @movies = Movie.where
    
    ##Part 1 (will comment out when it has to be updated for future sections)
    
    #@movies = Movie.order(params[:sort_by]) ##we will order using the sort_by param
    #@sort_column = params[:sort_by] ##columns will be sorted
    
    ###################################################################################
    
    ##Part 2
    
    ##The first thing we need is an all_ratings object we can use in order to get all ratings
    @all_ratings = Movie.ratings
    
    ##next we we want to check if anything is checked if not then our rates will be all ratings
    ##if it is not nil then it will equal the ratings that are checked (not needed for part3)
    #params[:ratings].nil? ? @rates = @all_ratings : @rates = params[:ratings].keys
    
    

    #to create a sessiont to rembered for the sorting of columns update below line
    @sort_column = params[:sort_by] || session[:sort_by] ##columns will be sorted and session saved
    #sort movies when a rating is checked (or not) without breaking functionality of part 1 
    #@movies = Movie.where(rating: rates).order(params[sort_by]) 
    
    
    ###################################################################################
    
    
    ##Part 3 we wamt to implement sessions that remember where a user was
    ##possible examples of sessions
    ##Nothing is checked or sorted, go to more info, come back should be the same
    ##check box is checked, no column is sorted, go to more info come back, check box is checked, no column is sorted
    ##check box is checked, column(s) is sorted, go to more info come back, check box is checked, column(s) is sorted
    ##no check box is checked, column(s) is sorted, go to more info come back, no  check box is checked, column(s) is sorted
    
    ##Update some code above to make sessions (example: sorting)
    
    ##session for ratings for when we already have a session or @all_ratings exists
  
    session[:ratings] = session[:ratings] || {'G'=>'', 'PG'=>'', 'PG-13'=>'', 'R'=>''}
    
    ##Our variable from above, rates, can be updated to include a ratings sessions
    @rates = params[:ratings] || session[:ratings]
    
    session[:sort_by] = @sort_column
    session[:ratings] = @rates
    
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort_by]) 
    
    ##update Movie.where... line above to remember sessions
    
    ##no sort_by parameter and a sort_by session or ratings parameter is nil and no session rating we want to redirect
    
    
    
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
