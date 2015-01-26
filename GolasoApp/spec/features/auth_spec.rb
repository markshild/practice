require 'spec_helper'

feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url

    expect(page).to have_content "Sign Up"
  end

  feature "signing up a user" do

    scenario "shows username on the homepage after signup" do
      sign_up('Mark','Mark12')

      expect(page).to have_content 'Mark'
    end

    scenario "shows error messages on incorrect sign up" do
      sign_up('', 'Tdfsdfs')
      expect(page).to have_content "Username can't be blank"
    end

  end

end

feature "logging in" do

  before(:each) do
    sign_up('John', 'Cihangir')
    click_button "Log Out"
  end

  scenario "shows username on the homepage after login" do
    login('John', 'Cihangir')

    expect(page).to have_content "John"
  end

  scenario "shows log out button on the homepage after login" do
    login('John', 'Cihangir')

    expect(page).to have_button "Log Out"
  end

end

feature "logging out" do

  scenario "begins with logged out state" do
    visit new_session_url
    expect(page).to have_content "Sign Up"
  end

  scenario "doesn't show username on the homepage after logout" do
    sign_up('John', "Markcity")
    click_button "Log Out"
    expect(page).to_not have_content "John"

  end

end
