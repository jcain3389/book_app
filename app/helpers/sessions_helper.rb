module SessionsHelper
  #After a user signs in, we'll need to access their information throughout our entire application.  Therefore, we need to break out session-management tasks into this universal 'sessions_helper'.
  #This is a helper module, which are packages of code that can be added into other classes.
  #We add this session helper into our main application controller, which will provide its behaviors to all other controllers via inheritance.

  #CURRENT USER METHODS (3)

  #Getter Method:
  def current_user
    remember_token = User.hash(cookies[:remember_token]) #Grab any remember-token that exists within the cookie; Rails voodoo.
    @current_user ||= User.find_by(remember_token: remember_token) #Try to find a user with a matching hashed token.
  end

  #Setter Method:
  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    current_user == user #Sees if the result of the current_user method equals the user input.
  end

  #SIGNIN STATUS METHODS (3)

  def signed_in?
    !current_user.nil? #Makes sure there is a current user.
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    self.current_user = user
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  #LOCATION MANAGEMENT METHODS (2)

  def store_location
    if request.get?
      session[:return_to] = request.url
    end
  end

  #This method can be used in place of a normal redirect_to method in cases where the user was asked to sign in before completeing an action.
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  #SECURITY CHECKPOINT METHOD: used in any controller's before_action to prevent the user from accessing content without signing in.
  def require_signin
    if !signed_in?
      store_location
      flash[:notice] = "Please sign in."
      redirect_to signin_url
    end
  end
end
