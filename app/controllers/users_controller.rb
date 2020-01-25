class UsersController < ApplicationController
  def index     #ユーザー一覧ページ。ユーザーの一覧を取得
    @users = User.order(id: :desc).page(params[:page]).per(10)
  end

  def show      #ユーザー詳細ページ。ユーザー個々のidを取得
    @user = User.find(params[:id])
  end

  def new       #アカウント新規登録ページ。
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザーを登録しました。"
      redirect_to @user
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