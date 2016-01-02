require 'test_helper'

class UserTest < ActiveSupport::TestCase

  #################################
  # 1 Test object validity (with hidden has_secure_password validations)
  #################################
   def setup
     @user = User.create(email: "user@example.com", password: "password", password_confirmation: "password")
     @new_user = User.new(email: "new.user@example.com", password: "password", password_confirmation: "password")
     # @same_email_user = User.new(email: "user@example.com", password: "piep", password_confirmation: "piep")
     # @no_mail_user = User.new(email: "", password: "password", password_confirmation: "password")
     # @no_pass_user = User.new(email: "no_pass_user@example.com", password: "", password_confirmation: "")
     # @no_match_user = User.new(email: "no_match_user@example.com", password: "match", password_confirmation: "nomatch")
     # @error_mail_user = User.new(email: "error@example", password: "password", password_confirmation: "password")
  #
   end

  should validate_presence_of(:email)
  should validate_presence_of(:password)
  should validate_confirmation_of(:password)
  should have_secure_password
  should validate_uniqueness_of(:email)

   test 'save email as downcase' do
     @user.email = 'dOWNCaSe@example.com'
     @user.save
     assert_equal @user.email, 'downcase@example.com'
     assert_equal @user.email, @user.reload.email
   end

  test 'accepts standard email adresses' do
    valid_adresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+rabbit@baz.cn]
    valid_adresses.each do |adres|
      @user.email = adres
      assert @user.valid?, "#{valid_adresses.inspect} should be valid"

      end
  end

  # PENDING! TODO: add notice or javascript for dubious emailadresses

  # test 'shows warning for dubious emailadress' do
  #   dubious_adresses = %w[user@example,com user_at_foo.org user.you@example foo@bar_baz.com foo@bar+baz.nl]
  #   #controller = UsersController.new
  #   dubious_adresses.each do |adres|
  #     @user.email = adres
  #    # expect(controller).to set_flash[:alert].to(/are not valid/).now
  #   end
  # end

  ########################################
  # 2 Test making and saving of new users
  ########################################

  test "don't save to database" do
    assert_no_difference 'User.count' do
      @new_user
    end
  end

  test "save to database" do
    assert_difference 'User.count', 1 do
      @new_user.save
    end
  end

  ########################################
  # 3 The story continues with integration test in /users_signup_test
  ###########################################


end
