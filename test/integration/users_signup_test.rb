require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  ############################
  # 3 testing signups (see user_test.rb for step #1 and #2)
  #############################

  def setup
    @user = User.create(email: "user@example.com", password: "password", password_confirmation: "password")
  end

  test "invalid sign_up information" do
    get aanmelden_path
    assert_no_difference 'User.count' do
      post users_path, user: { email: "user@invalid",
      password: "foo", password_confirmation: "Poo" }
      #BUT the invalid email does pass in reality
    end
  end


  test 'valid sign_up information' do
    get aanmelden_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { email: "brandnew@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'
  end


  # Does not work properly
  # test "login with valid information" do
  #   get inloggen_path
  #   post sessions_path, session: { email: @user.email, password: 'password' }
  #   assert_redirected_to @user
  #   follow_redirect!
  #   assert_template 'users/show'
  #   assert_select "a[href=?]", login_path, count: 0
  #   assert_select "a[href=?]", logout_path
  #   assert_select "a[href=?]", user_path(@user)
  # end

end