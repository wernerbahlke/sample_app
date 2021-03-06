class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only   => [:edit, :update]
  before_filter :admin_user,   :only   => :destroy

  # GET /users
  # GET /users.xml
  def index
    if params[:search]
      @title = "Show user"
      @users = User.search(params[:search]).paginate(:page => params[:page])
    else
      @title = "All users"
      @users = User.paginate(:page => params[:page])
    end
    respond_to do |format|
      format.html
      format.xml { render :xml => @users.to_xml }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    if params[:search]
        @microposts = @user.microposts.search(params[:search]).paginate(:page => params[:page])
      else
        @microposts = @user.microposts.paginate(:page => params[:page])
      end    
    @title = @user.name
    respond_to do |format|
      format.html
      format.xml { render :xml => @microposts.to_xml }
    end
  end

  # GET /users/new
  def new
    if !signed_in?
      @user = User.new
      @user.password = ""
      @title = "Sign up"
    else
      redirect_to(root_path)
    end
  end

  # POST /users
  # POST /users.xml
  def create
    if !signed_in?
      @user = User.new(params[:user])

      respond_to do |format|
        if @user.save
          sign_in @user
          flash[:success] = "Welcome to the Sample App!"
  
          format.html { redirect_to user_url(@user) }
          format.xml do
            headers["User"] = user_url(@user)
            render :nothing => true, :status => "201 Created"
          end
        else
          @title = "Sign up"
          @user.password = ""
          @user.password_confirmation = ""
          format.html { render :action  => "new" }
          format.xml  { render :xml     => @user.errors.to_xml }
        end
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

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    user = User.find(params[:id])
    if user != current_user
      user.destroy
      flash[:success] = "User destroyed."
    else
      flash[:alert] = "You cannot destroy yourself!"
    end
    respond_to do |format|
      format.html { redirect_to users_path }
      format.xml  { render :nothing => true }
    end
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
