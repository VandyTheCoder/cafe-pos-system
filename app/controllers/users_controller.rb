class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users
  def index
    @grid = UsersGrid.new(grid_params) do |scope|
      scope.page(params[:page])
    end
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.is_super_admin?
      user_params.delete(:role)
    end
    if @user.update_without_password(user_params)
      if user_params[:password].present?
        @user.reset_password(user_params[:password], user_params[:password])
      end
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    if @user.is_super_admin?
      redirect_to users_url, notice: "Can't destroy super admin.", status: :see_other
    else
      @user.destroy!
      redirect_to users_url, notice: "User was successfully destroyed.", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(
        :name,
        :gender,
        :picture,
        :role,
        :email,
        :password,
        :password_confirmation
      )
    end

    def grid_params
      params.fetch(:users_grid, {}).permit!
    end
end
