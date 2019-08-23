class UserController < ApplicationController    
  def channel_management
    @chaid=MCha.select("name,id").where("workspace_id=?",session[:workspace_id])
    @arrChaAdmin=[]
    for id in @chaid
      @chaadminid=TRelationship.select("user_id,cha_id,created_at").where("t_relationships.workspace_id=? and cha_id=?", session[:workspace_id],id.id).order(created_at: :asc)
      @arrChaAdmin << @chaadminid[0]  
    end
    menu
  end
  def delete 
    MCha.find_by(id: params[:cha_id]).destroy
    TRelationship.where("cha_id=? and workspace_id=?", params[:cha_id],session[:workspace_id]).destroy_all
    TChamsg.where("cha_id=?", params[:cha_id]).destroy_all
    redirect_to channelmanagement_path
  end

  def member_management
    @user_list=MUser.select("distinct m_users.name,m_users.id")
    .joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.workspace_id=? and t_relationships.user_id!=?",session[:workspace_id],session[:user_id]) 
    
    menu
  end
   
  def remove
    TRelationship.where("user_id=? and workspace_id=?", params[:user_id],session[:workspace_id]).destroy_all
    TDmsg.where("sender_id=? and workspace_id=?", params[:user_id],session[:workspace_id]).destroy_all
    TChamsg.where("sender_id=? and workspace_id=?", params[:user_id],session[:workspace_id]).destroy_all
  
    redirect_to membermanagement_path
  end
end
