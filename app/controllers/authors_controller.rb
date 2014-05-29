class AuthorsController < ApplicationController
  def index
    @user = current_user
    @authors = current_user.authors
  end

  def create
    author = Author.find_or_create_by(name: params[:author][:name])
    author.update(author_params)
    current_user.authors << author
    redirect_to user_authors_path
  end

  def destroy
    @author = Author.find(params[:id])
    @author.destroy
    redirect_to user_authors_path
  end

  def results
    @results = get_author(params[:query])
  end

  def selection
    @selection = get_author_info(params[:id])

    if @selection["about"] == nil
      @author_about = "No info provided."
    else
      @author_about = @selection["about"]
    end
    @author = Author.new
    @user = current_user
  end

  def books
    @books = get_author_books(params[:id])
  end

  private

  def get_author(search)
    name = search.gsub(" ", "+")
    author_page = HTTParty.get("https://www.goodreads.com/api/author_url/#{name}?key=#{ENV['GR_API_KEY']}")
    author_info = author_page["GoodreadsResponse"]["author"]
    return author_info
  end

  def get_author_info(id)
    response = HTTParty.get("https://www.goodreads.com/author/show/#{id}.xml?key=#{ENV['GR_API_KEY']}")
    author_stuff = response["GoodreadsResponse"]["author"]
    return author_stuff
  end

  def get_author_books(id)
    author_books = HTTParty.get("https://www.goodreads.com/author/list/#{id}.xml?key=#{ENV['GR_API_KEY']}")
    books = author_books["GoodreadsResponse"]["author"]["books"]["book"]
    return books
  end

  def author_params
    params.require(:author).permit(:name, :gra_id)
  end

end
