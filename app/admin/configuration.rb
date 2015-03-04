ActiveAdmin.register Configuration do
  actions :only => [:index, :update]

  before_filter do
    @skip_sidebar = true
  end

  config.comments = false
  config.clear_action_items!

  controller do
    def index
      params[:action] = "Configuration" # for the active admin title
      render 'admin/settings/index', layout: 'active_admin'
    end

    def update
      params[:update_configuration].each do |setting, value|
        Configuration.send("#{setting}=", value)
      end
      redirect_to :back, notice: "Settings Saved"
    end
  end
end
