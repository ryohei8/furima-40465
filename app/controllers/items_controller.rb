class ItemsController < ApplicationController
  before_action :get_item_id, only: [:show, :edit, :update, :destroy, :move_to_index]
  before_action :move_to_login, only: [:new, :edit]
  before_action :move_to_index, only: [:edit]


  def index
    @items = Item.order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if user_signed_in? && (current_user.id == @item.user_id)
      @item.destroy
      redirect_to root_path # rubocop:disable Style/IdenticalConditionalBranches
    else
      redirect_to root_path # rubocop:disable Style/IdenticalConditionalBranches
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :condition_id, :shipping_cost_burden_id, :province_id,
                                 :shipping_day_id, :price, :image).merge(user_id: current_user.id)
  end

  def get_item_id # rubocop:disable Naming/AccessorMethodName
    @item = Item.find(params[:id])
  end

  def move_to_index
    if @item.purchase_record.present? || (current_user && current_user.id != @item.user_id)
      redirect_to root_path
    end
  end

  def move_to_login
    redirect_to new_user_session_path if current_user.nil?
  end
end
