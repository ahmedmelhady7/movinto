class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  def index
  end
  
  def new
    @review = Review.new
  end
  
  def edit
  end
  
  def create
    @review = @movie.reviews.build(review_params)
    @review.user_id = current_user.id
    if @review.save
      puts "*************************#{@movie.average_rating}*************************"
      @movie.average_rating = @movie.reviews.average(:rating)
      @movie.save
      puts "*************************#{@movie.average_rating}*************************"
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js
      end
    else
      flash[:alert] = "check the review form again, something went wrong."
      render root_path
    end
  end
  
  def update
    respond_to do |format|
      if @movie.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @review = @movie.reviews.find(params[:id])
    if @review.user_id==current_user.id 
      @review.destroy
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js
      end
    end
  end
  
  private
    def set_movie
      @movie = Movie.find(params[:movie_id])
    end
  
    def set_review
      @review = Review.find(params[:id])
    end
    
    def review_params
      params.require(:review).permit(:content,:rating)
    end
  
end
