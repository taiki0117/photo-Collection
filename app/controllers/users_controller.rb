class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit] #ログインしていないと表示できないようにしている
  before_action :correct_user, only: [:edit, :update, :destroy]
  
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
      session[:user_id] = @user.id #このコードを使ってログインしている状態にしてるので二行目のrequire_user_logged_inではじかれない。※自主学習
      redirect_to @user  #user_path(@user.id)を略している
    else
      flash[:danger] = "ユーザーの登録に失敗しました。"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id]) #編集するユーザを取得
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = '正常に更新されました'
      redirect_to @user
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:success] = "退会しました。"
    redirect_to login_url
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page]).per(10)
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page]).per(10)
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @fav_posts = @user.fav_posts.page(params[:page])
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :image, :password, :password_confirmation)
  end
  
  def correct_user    #ユーザー編集ページがログインユーザーの物なのか確認している
    user = User.find(params[:id])
    if current_user != user
      redirect_to user_path(current_user.id)
    end
  end
end