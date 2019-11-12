class FriendshipsController < ApplicationController
    before_action :authenticate_user!
    
    def create
        friend = User.find(params[:friend_id])
        params[:user_id] = current_user.id

        Friendship.create(friendship_params) unless current_user.follows_or_some?(friend)
        redirect_to root_path
    end

    def show
        @friend = Friendship.find(params[:id]).friend
        @exercises = @friend.exercises
    end

    def destroy
        @friendship = Friendship.find(params[:id])
        friendname = @friendship.friend.full_name
        
        if @friendship.destroy
            flash[:success] = "#{friendname} unfollowed."
        else
            flash[:danger] = "#{friendname} could not be
            unfollowed."
        end
        redirect_to user_exercises_path(current_user)
    end

    private

    def friendship_params
        params.permit(:friend_id, :user_id)
    end
end