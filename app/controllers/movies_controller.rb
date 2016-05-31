class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings = params[:ratings].nil? ? Movie.all_ratings : params[:ratings].keys

    sort_by = params[:sort_by]

    if sort_by.eql? 'title'
      @movies = Movie.find(:all, :order => :title)
      @sort_by = :title
    elsif sort_by.eql? 'release_date'
      @movies = Movie.find(:all, :order => :release_date)
      @sort_by = :release_date
    else
      @movies = Movie.where(:rating => [@selected_ratings])
    end

    all_ratings = Movie.all_ratings
    @checked_ratings = Hash.new
    all_ratings.each do |rating| 
      @checked_ratings[rating.to_sym] = @selected_ratings.include? rating
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
