require 'spec_helper'

feature "User commenting" do
  before(:each) do
    sign_up('makr', 'ttired')
  end

  scenario "can comment on a user" do
    fill_in 'Comment', with: 'lose weight, FATTY!!!'
    click_on 'Submit Comment'

    expect(page).to have_content 'lose weight, FATTY!!!'
  end

  scenario "records commentor's name" do
    click_on 'Log Out'
    sign_up('sfljkd', 'a;fdsjkl')
    visit user_url(User.first)
    fill_in 'Comment', with: 'lose weight, FATTY!!!'
    click_on 'Submit Comment'

    expect(page).to have_content 'sfljkd'
  end

end

feature "Goal commenting" do
  before(:each) do
    sign_up('User', 'password')
    click_on "Add Goal"
    fillin_goal('Sleep', 'sleep more!!!!!')
    choose('Public')
    click_on "Submit"
  end

  scenario "can comment on a goal" do
    fill_in 'Comment', with: 'something'
    click_on "Submit Comment"

    expect(page).to have_content 'something'
  end

  scenario "records commentor's name" do
    click_on 'Log Out'
    sign_up('sfljkd', 'a;fdsjkl')
    visit user_url(User.first)
    fill_in 'Comment', with: 'something'
    click_on "Submit Comment"

    expect(page).to have_content 'sfljkd'
  end

end
