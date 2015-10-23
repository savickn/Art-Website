module FeatureHelpers
  def logged_as(user)
    page.set_rack_session('warden.user.user.key' => User.serialize_into_session(user).unshift("User"))
  end
end