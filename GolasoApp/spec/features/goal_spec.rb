require 'spec_helper'

feature "user" do
  before(:each) do
    sign_up('User', 'password')
    click_on "Add Goal"
    fillin_goal('Sleep', 'sleep more!!!!!')
    choose('Public')
    click_on "Submit"
  end

  scenario "can create a goal" do
    expect(page).to have_content "Sleep"
  end

  scenario "can update a goal" do
    click_on "Edit"
    fillin_goal("Eat", "EAT MOAR!!!")
    click_on "Submit"

    expect(page).to have_content "Eat"
  end

  scenario "can delete a goal" do
    click_on "Delete"

    expect(page).to_not have_content "Sleep"
  end

  scenario "can see all personal goals" do
    visit user_url(User.first)
    click_on "Add Goal"
    fillin_goal('Dance', 'dance in the rain?')
    choose('Private')
    click_on "Submit"

    expect(page).to have_content "Dance"
  end

  scenario "can complete a goal" do
    click_on "Complete"
    expect(page).to have_content "COMPLETED!!!!!!!!!!!!!!!!!!!!!!!!"
  end

  feature "other user" do
    before(:each) do
      visit user_url(User.first)
      click_on "Add Goal"
      fillin_goal('Dance', 'dance in the rain?')
      choose('Private')
      click_on "Submit"
      click_on "Log Out"
      sign_up('Mark', 'lsdfljksd')
      visit user_url(User.first)
    end

    scenario "can see public goals" do
      expect(page).to have_content "Sleep"
    end

    scenario "cannot see private goals" do
      expect(page).to_not have_content "Dance"
    end

    scenario "cannot add a goal" do
      expect(page).to_not have_link "Add Goal"
    end

    scenario "cannot update a goal" do
      expect(page).to_not have_link "Edit"
    end

    scenario "cannot delete a goal" do
      expect(page).to_not have_button "Delete"
    end

  end

end
