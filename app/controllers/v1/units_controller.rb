module V1
    class UnitsController < ApplicationController
      before_action :require_owner
      def index
        @units = Unit.all
      end
  
      def show
        @unit = Unit.find(params[:id])
      end
  
      def new
        @unit = Unit.new
      end
    end
  end