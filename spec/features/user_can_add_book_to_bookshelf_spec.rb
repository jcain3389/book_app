require 'spec_helper'

describe "A user can add a book to their bookshelf" do
  let(:user) { FactoryGirl.create(:user)}
  let(:freedom) { Book.create(title: "Freedom", author: "Jonathan Franzen", grb_id: 7905092)}

  it "can view a book's info page" do
    visit books_selection_path + "?id=7905092"
    expect(page).to have_content(freedom.title)
    expect(page).to have_content(freedom.author)
  end

  it "can add a book to their shelf" do
    login(user)
    visit books_selection_path + "?id=#{freedom.grb_id}"
    fill_in :title, with: freedom.title
    fill_in :author, with: freedom.author
    fill_in :grb_id, with: freedom.grb_id
    click_button("submit")
    expect(page).to have_content(freedom.title)
    expect(page).to have_content(freedom.author)
  end

  it "can update a book to 'read'" do
    login(user)
    visit user_books_path(user.id)
    fill_in :read, with: true
    click_button("update")
    expect(page).to have_content("read")
  end

  it "can destroy a book" do
    login(user)
    visit user_books_path(user.id)
    click_button("destroy")
    expect(page).to_not have_content
  end

  def login(user)
    visit "/signin"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end
