class RelationshipsController < ApplicationController

  def follow
    current_user.follow(params[:id])
    current_user.create_notification_follow!(current_user)
    respond_to do |format|
      format.html {redirect_back(fallback_location: root_url)}
      format.js 
    end
    
  end

  def unfollow
    current_user.unfollow(params[:id])
    redirect_back(fallback_location: users_path)
  end

end

