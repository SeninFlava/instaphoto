class ProfilesController < ApplicationController
  before_action :get_user, except: [:my_subscribers, :my_photo, :my_subscribers_photo, :all_users]
  before_action :is_login, only: [:subscribe, :unsubscribe]

  def show
  end

  
  def subscribe

  	if current_user.id == @user.id 
  		redirect_to profile_path(@user.id), alert: "Вы не можете подписаться на самого себя" 
  	else  		
  	
	  	unless current_user.subscriptions.find_by(friend_id: @user.id).nil?
		  	redirect_to profile_path(@user.id), alert: "Вы уже подписаны на #{@user.email}"  		
	  	else 
		  	@subscribtion = current_user.subscriptions.build
		  	@subscribtion.friend_id = @user.id
		  	if @subscribtion.save 
		  		redirect_to profile_path(@user.id), notice: "Вы подписаны на #{@user.email}"
		  	else
		  		redirect_to profile_path(@user.id), alert: "Ошибка при подписке на #{@user.email}"  		
		  	end
	  
	  	end

  	end
  end

  
  def unsubscribe

  	@subscribtion = current_user.subscriptions.find_by(friend_id: @user.id)
  	unless @subscribtion.nil?
  		@subscribtion.destroy
  		redirect_to profile_path(@user.id), notice: "Вы отписаны от #{@user.email}"
  	else 
  		redirect_to profile_path(@user.id), alert: "Вы не были подписаны на #{@user.email}"
  	end

  end



  def my_subscribers
  	@subscribers = User.where(id: current_user.subscriptions.pluck(:friend_id))
  end

  def my_photo
  	@photos = current_user.photos.order('created_at DESC')
  end

  def my_subscribers_photo
  	@photos = Photo.where(user_id: current_user.subscriptions.pluck(:friend_id)).order('created_at DESC')
  end

  def all_users
    @users = User.all.paginate(:page => params[:page], :per_page => 10)
  end




private 

	def get_user
		@user = User.find_by(id: params[:id])
		if @user.nil?
			redirect_to root_path, alert: "Нет пользователя с id=#{params[:id]}"
		end
	end
  	
  	def is_login
  		if current_user.nil? 
  			redirect_to photos_path, alert: "Чтобы подписываться(отписываться) на пользователей, необходимо авторизоваться"
  		end
  	end


end
