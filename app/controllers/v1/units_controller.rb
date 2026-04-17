module V1
  class UnitsController < ApplicationController
    before_action :require_owner
    before_action :set_unit, only: [:show, :edit, :update, :destroy]

    def index
      @units = current_user.owned_units
    end

    def show
    end

    def new
      @unit = Unit.new
      @units = current_user.owned_units
    end

    def create
      @unit = current_user.owned_units.build(unit_params)

      if @unit.save
        redirect_to v1_units_path, notice: "Unit created successfully"
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @unit.update(unit_params)
        redirect_to v1_units_path, notice: "Unit updated successfully"
      else
        render :edit
      end
    end

    def destroy
      @unit.destroy
      redirect_to v1_units_path, notice: "Unit deleted"
    end

    private

    def set_unit
      @unit = current_user.owned_units.find(params[:id])
    end

    def unit_params
      params.require(:unit).permit(:name, :rent_amount, :status)
    end
  end
end