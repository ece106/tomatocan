class StaticPagesController < ApplicationController
  def home
    userswithyoutube = User.where("LENGTH(youtube1) < 20 AND LENGTH(youtube1) > 4 ")
    usersvidorder = userswithyoutube.order('updated_at DESC')
    @users = usersvidorder.paginate(:page => params[:page], :per_page => 18)
  end

  def howwork
  end

end
