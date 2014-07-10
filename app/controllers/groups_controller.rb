class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.all
    if params[:search].present?
      @groups = Group.near(params[:search], params[:dist], order: 'distance')
    else
      @groups = Group.near([current_user.latitude, current_user.longitude], 15, order: 'distance') #near current_user(lat long)
    end
  end

  # GET /groups/1
  def show
    @user = User.find(@group.user_id)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = current_user.groups.build(group_params)

    if @group.save
      redirect_to @group
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to @group
    else
      render action: 'edit'
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit( :grouptype, :name, :address, :latitude, :longitude, :user_id, :about, :grouppic )
    end
end
