class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit] #ログインしていないと表示できないようにしている
  
  def index     #ユーザー一覧ページ。ユーザーの一覧を取得
    @users = User.order(id: :desc).page(params[:page]).per(10)
  end

  def show      #ユーザー詳細ページ
    @user = User.find(params[:id])    #ユーザー個々のidを取得
    @posts = @user.posts.order(id: :desc).page(params[:page]) #投稿の一覧を取得
    counts(@user)
  end

  def new       #アカウント新規登録ページ。
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザーを登録しました。"
      session[:user_id] = @user.id #このコードを使ってログインしている状態にしてるので二行目のrequire_user_logged_inではじかれない。
      redirect_to @user  #user_path(@user.id)を略している
    else
      flash[:danger] = "ユーザーの登録に失敗しました。"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end