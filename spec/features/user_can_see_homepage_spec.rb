require 'spec_helper'

describe 'A user can see the homepage' do

  it 'has the title BookSmart' do
    visit root_path
    expect(page).to have_content 'BookSmart'
  end

end
