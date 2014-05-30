class BooksController < ApplicationController
  def index
    @books = current_user.books
    @user = current_user
  end

  def create
    book = Book.find_or_create_by(title: params[:book][:title])
    book.update(book_params)
    current_user.books << book
    redirect_to user_books_path
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.update(book_params)
    redirect_to user_books_path
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to user_books_path
  end

  def results
    @results = get_book(params[:book_query])
    if @results == nil
      flash[:error] = "This book isn't real."
      redirect_to root_path
    end

    @num_results = @results["GoodreadsResponse"]["search"]["results_end"]

    if @results["GoodreadsResponse"]["search"]["results"] == nil
      flash[:error] = "This book isn't real."
      redirect_to root_path
    else
      @book_results = @results["GoodreadsResponse"]["search"]["results"]["work"]
    end


    # if @book_results == nil || @num_results == nil

    #   flash[:error] = "This herpderp isn't real."
    #   redirect_to root_path
    # end
  end

  def selection
    @selection = get_book_info(params[:id])
    if @selection["authors"]["author"].class == Hash
      @author_name = @selection["authors"]["author"]["name"]
    elsif @selection["authors"]["author"].class == Array
      @author_name = @selection["authors"]["author"][0]["name"]
    end
    if @selection["description"] == nil
      @selection_desc = "No description provided."
    else
      @selection_desc = @selection["description"]
    end
    @book = Book.new
  end

  def reviews
    @review = get_book_review(params[:id])
  end

  private

  def get_book(search)
    title = search.gsub(" ", "+")
    book_page = HTTParty.get("https://www.goodreads.com/search.xml?key=#{ENV['GR_API_KEY']}&q=#{title}")
    return book_page
  end

  def get_book_info(id)
    book_page = HTTParty.get("https://www.goodreads.com/book/show/#{id}?format=xml&key=#{ENV['GR_API_KEY']}")
    book_stuff = book_page["GoodreadsResponse"]["book"]
    return book_stuff
  end

  def get_book_review(id)
    book_review = HTTParty.get("https://www.goodreads.com/book/show/#{id}?format=json&key=#{ENV['GR_API_KEY']}")
    return book_review
  end

  def book_params
    params.require(:book).permit(:title, :author, :read, :grb_id)
  end
end
