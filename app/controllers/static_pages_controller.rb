class StaticPagesController < ApplicationController
  def home
    userswithyoutube = User.where("LENGTH(youtube1) < ? AND LENGTH(youtube1) > ? AND author = ?", 20, 4, 2)
    authorsvidorder = userswithyoutube.order('updated_at DESC')
    @authors = authorsvidorder.paginate(:page => params[:page], :per_page => 12)
    @authorwithpic = User.where("profilepicurl IS NOT NULL AND profilepicurl != '' ")
    @projwithpic = Project.where("projectpic IS NOT NULL AND projectpic != '' ")
    @groupwithpic = Group.where("grouppic IS NOT NULL AND grouppic != '' ")
  end

  def howwork
  end

end
