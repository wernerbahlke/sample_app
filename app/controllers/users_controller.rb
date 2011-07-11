class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only   => [:edit, :update]
  before_filter :admin_user,   :only   => :destroy

  def index
    if params[:search]
      @title = "Show user"
      @users = User.search(params[:search]).paginate(:page => params[:page])
    else
      @title = "All users"
      @users = User.paginate(:page => params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    if params[:search]
        @microposts = @user.microposts.search(params[:search]).paginate(:page => params[:page])
      else
        @microposts = @user.microposts.paginate(:page => params[:page])
      end    
    @title = @user.name
  end

  def new
    if !signed_in?
      @user = User.new
      @user.password = ""
      @title = "Sign up"
    else
      redirect_to(root_path)
    end
  end

  def create
    if !signed_in?
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        @title = "Sign up"
        @user.password = ""
        @user.password_confirmation = ""
        render 'new'
      end
    else
      redirect_to(root_path)
    end
end

  def edit
    @title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user != current_user
      user.destroy
      flash[:success] = "User destroyed."
    else
      flash[:alert] = "You cannot destroy yourself!"
    end
    redirect_to users_path
  end

  def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render 'show_follow'
   end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
