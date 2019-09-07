class FavoritesController < ApplicationController
  
  before_action :require_user_logged_in
   
  def create
         
    micro = Micropost.find(params[:micropost_id])

    current_user.favorite(micro)
    flash[:success] = 'お気に入り登録をしました'
    redirect_to root_url
    
  end

  def destroy
    micro = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micro)
    flash[:success] = 'お気に入り登録を解除しました。'
    redirect_to root_url
    
  end
  
  private
  
    def correct_user
        @favo = current_user.favorites.find_by(id: params[:id])
        unless @favo
          redirect_to root_url
        end
    end
  
  
end
