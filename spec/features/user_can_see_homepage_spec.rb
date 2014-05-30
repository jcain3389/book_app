require 'spec_helper'

describe 'A user can see the homepage' do

  it 'has the title BookSmart' do
    visit root_path
    expect(page).to have_content 'BookSmart'
  end

  it 'can search for an author by name' do
    visit root_path
    fill_in "Search for author:", with: "Ernest Hemingway"
    click_button("author_submit")
    expect(page).to have_content "Ernest Hemingway"
  end

  it 'can search for a book by title' do
    visit root_path
    fill_in "Search for book:", with: "Blink"
    click_button("book_submit")
    expect(page).to have_content "Blink"
  end

end
