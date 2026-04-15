require "test_helper"

class TenantDashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tenant_dashboard_index_url
    assert_response :success
  end
end
