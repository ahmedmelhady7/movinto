class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :set_genres, only: [:index, :featured_movies, :opening_this_week]
  # GET /movies
  # GET /movies.json
  def index
    if params[:movie] and params[:movie][:genre_id]
      @movies = Movie.joins(:genres).where(:genres => {:id => params[:movie][:genre_id]})
      @message = "Listing Movies with #{Genre.find(params[:movie][:genre_id]).name} Genre"
    else
      @movies = Movie.all
      @message = "Listing Movies"
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  def featured_movies
    if params[:movie] and params[:movie][:genre_id]
      @movies = Movie.joins(:genres).where(:genres => {:id => params[:movie][:genre_id]}).where('is_featured = ?', true)
      @message = "Listing Featured Movies with #{Genre.find(params[:movie][:genre_id]).name} Genre"
    else
      @movies = Movie.where('is_featured = ?', true)
      @message = "Listing Featured Movies"
      if @movies.size==0
        flash[:alert] = "No Featured movies right now."
        redirect_to root_path
      end
    end
  end
  
  def opening_this_week
    if params[:movie] and params[:movie][:genre_id]
      @movies = Movie.joins(:genres).where(:genres => {:id => params[:movie][:genre_id]}).where('released_at > ? AND released_at < ?', Date.today, Date.today + 7.days)
      @message = "Listing Movies opening this week with #{Genre.find(params[:movie][:genre_id]).name} Genre"
    else
      @movies = Movie.where('released_at > ? AND released_at < ?', Date.today, Date.today + 7.days)
      @message = "Listing Movies opening this week"
      if @movies.size==0
        flash[:alert] = "No movies opening this week."
        redirect_to root_path
      end
    end
  end
  
  def wishlist
    @wishlist = current_user.wishlist
    if @wishlist
      @movies = current_user.wishlist.movies
      if @movies.size==0
        flash[:alert] = "No movies in your wishlist right now."
        redirect_to root_path
      end
    else
      @wishlist = Wishlist.new
      @wishlist.user_id = current_user.id
      @wishlist.save
    end
  end
  
  def add_to_wishlist()
    @wishlist = current_user.wishlist
    movie = Movie.find(params[:movie_id])
    if @wishlist
      if @wishlist.movies.include? movie
        flash[:alert] = "you already added this movie before to your wishlist"
        redirect_to wishlist_path
      else
        @wishlist.movies << movie
        redirect_to wishlist_path
      end
    else
      @wishlist = Wishlist.new
      @wishlist.user_id = current_user.id
      @wishlist.save
      @wishlist << movie
      redirect_to wishlist_path
    end
  end
  
  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def set_genres
      @genres = Genre.all
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:name, :is_featured, :released_at, :average_rating)
    end
  
    def is_admin
      unless current_user.is_admin
        flash[:alert]="you are not allowed to view this page!"
        redirect_to root_path
      end
    end
  
end
