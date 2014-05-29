class UsersController < ApplicationController
  #User signin required in order to access actions within the users controller
  before_action :require_signin, except: [:new, :create]
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :require_current_user, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save #Evaluates to 't' or 'f' based on whether or not the validations in user.rb model passed when user_params was entered.
      sign_in @user #Automatically signs in newly-created users.
      redirect_to @user #Redirects to that new user's page.
    else
      render :new #If you messed up you get taken back to the form to re-enter your info.
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params) #Same as with the create method.
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def require_current_user
    if !current_user?(@user)
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    #This whitelists fields called 'password' and 'password_confirmation', though the corresponding field in the database was 'password_digest'.  The voodoo of 'has_secure_password' handles mapping these two input fields into one encrypted password digest.
  end
end
