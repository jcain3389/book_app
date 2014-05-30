require 'spec_helper'

describe "a user can add an author to their author list" do
  let(:user) {FactoryGirl.create(:user)}
  let(:cormac) {Author.create(name: "Cormac McCarthy", gra_id: 4178)}

  it "can view an author's info page" do
    visit authors_selection_path + "?id=#{cormac.gra_id}"
    expect(page).to have_content(cormac.name)
  end

  it "can add an author to their list" do
    login(user)
    visit authors_selection_path + "?id=#{cormac.gra_id}"
    fill_in :name, with: cormac.name
    fill_in :gra_id, with: 4178
    click_button("submit")
    expect(page).to have_content(cormac.name)
  end

  it "can destroy a book" do
  end

  def login(user)
    visit "/signin"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

end
