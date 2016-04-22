class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :following, :followers]
  before_action :validate_user, only: [:edit, :update]
#  before_action :other_group, only: [:preference]
  
  def show
    @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"

      # リレーション作成
      if @user.group != 1
        @other_group = User.where(group: 1)
        @same_group = User.where(group: 2)
      else
        @same_group = User.where(group: 1)
        @other_group = User.where(group: 2)
      end
      
      @other_group.each_with_index do |user, count|
        Relationship.create(follower_id: @user.id, followed_id: user.id, rank: count+1)
        Relationship.create(follower_id: user.id, followed_id: @user.id, rank: @same_group.count)
      end
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "success"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @users = @user.following_users
  end
  
  def followers 
    @users = @user.follower_users
  end

  def other_group
    if current_user.group != 1
      @users = User.where(group: 1)
    else
      @users = User.where(group: 2)
    end
  end
    
    
  def preference
    @users = current_user.following_users
    if params[:diff] != nil
      rank_temp = current_user.following_relationships.where(followed_id: params[:followed_id]).first.rank
      rank = params[:diff].to_i + rank_temp
      id_temp = current_user.following_relationships.where(rank: rank).first.followed_id
      current_user.following_relationships.where(followed_id: params[:followed_id]).update_all(:rank => rank)
      current_user.following_relationships.where(followed_id: id_temp).update_all(:rank => rank_temp)
    end
  end

  def matching
    # 初期化
    User.update_all(:match_id => nil)
    User.update_all(:propose_count => 0)
    @user = current_user


    while User.where(match_id: nil).count > 0 do
      if @user.group != 1
        @other_group = User.where(group: 1)
        @same_group = User.where(group: 2)
      else
        @same_group = User.where(group: 1)
        @other_group = User.where(group: 2)
      end
    
      @same_group.each do |user|
        if user.match_id == nil
          user.propose_count += 1
          @propose_id = user.following_relationships.find_by(rank: user.propose_count).followed_id
          @proposed_user = @other_group.find_by(id: @propose_id)
          
          if @proposed_user.match_id == nil
            # マッチング
            @proposed_user.match_id = user.id
            @proposed_user.save
            user.match_id = @propose_id
          elsif @proposed_user.following_relationships.find_by(followed_id: @proposed_user.match_id).rank > @proposed_user.following_relationships.find_by(followed_id: user.id).rank
            # マッチング解消
            @prev_user = @same_group.find_by(id: @proposed_user.match_id)
            @prev_user.match_id = nil
            @prev_user.save
            
            # マッチング
            @proposed_user.match_id = user.id
            @proposed_user.save
            user.match_id = @propose_id
          end
          user.save
        end
      end
    end
    if @user.group != 1
      @users = User.where(group: 2)
    else
      @users = User.where(group: 1)
    end
  end
  
  def create_preference
    if current_user.group != 1
      @other_group = User.where(group: 1)
      @same_group = User.where(group: 2)
    else
      @same_group = User.where(group: 1)
      @other_group = User.where(group: 2)
    end
    
    @other_group.each do |user|
      @score = current_user.favoriteships.where(rec_id: user.id).sum("score")
      @user = current_user.following_relationships.find_by(followed_id: user.id)
      @user.score = @score
      @user.save
    end
    @users = current_user.following_relationships_score
    
    @users.each_with_index do |user, count|
      user.rank = count+1
      user.save
    end
    
    redirect_to preference_user_path(current_user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :area, :profile, :password, :group,
                                 :password_confirmation)
  end
  
  def validate_user
    if current_user != @user
      redirect_to @user
    end
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end