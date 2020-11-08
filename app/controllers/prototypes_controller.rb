class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :delete, :update]
  before_action :move_to_index, only: :edit

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save #保存できればルートパスへ
      redirect_to root_path
    else #できなければ新規投稿画面へ戻る
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    prototype = Prototype.find(params[:id])
    
    if prototype.update(prototype_params) #更新できれば詳細ページへ
      redirect_to prototype_path
    else #できなければ編集画面へ戻る
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    if prototype.destroy
      redirect_to root_path
    end
  end
  
  def move_to_index
    unless current_user.id == Prototype.find(params[:id]).user_id 
      redirect_to action: :index
    end
 end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end

