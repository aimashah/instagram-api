require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "allows a user to sign up" do
    assert_difference("User.count") do
      post signup_url, params: {
        user: {
          name: "New User",
          email: "new@example.com",
          password: "password123"
        }
      }
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal "Signup successful", body["message"]
    assert body["token"].present?
    assert_equal "New User", body.dig("user", "name")
    assert_equal "new@example.com", body.dig("user", "email")
  end

  test "allows a user to log in" do
    user = User.create!(
      name: "Existing User",
      email: "login@example.com",
      password: "password123"
    )

    post login_url, params: { email: user.email, password: "password123" }

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal "Login successful", body["message"]
    assert body["token"].present?
    assert_equal user.email, body.dig("user", "email")
  end
end
