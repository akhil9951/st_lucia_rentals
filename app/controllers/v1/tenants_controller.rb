module V1
    class TenantsController < ApplicationController
      before_action :require_owner
      before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  
      def index
          @tenants = current_user.owned_tenants
      end
  
      def show
        @tenant = current_user.owned_tenants.find(params[:id])
      end
  
      def new
        @tenant = Tenant.new
      end
  

      def create
        @tenant = current_user.owned_tenants.build(tenant_params)
      
        if @tenant.save
          redirect_to v1_tenants_path, notice: "Tenant created successfully"
        else
          render :new
        end
      end

      def edit
      end
  
      def update
        if @tenant.update(tenant_params)
          redirect_to v1_tenant_path(@tenant), notice: "Updated successfully"
        else
          render :edit
        end
      end
  
      def destroy
        @tenant.destroy
        redirect_to v1_tenants_path, notice: "Deleted"
      end
  
      private
  
      def set_tenant
        @tenant = Tenant.find(params[:id])
      end
  
      def tenant_params
        params.require(:tenant).permit(:name, :email, :phone, :status)
      end
    end
end