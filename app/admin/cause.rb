ActiveAdmin.register Cause do
  config.filters = false
  scope :all, default: true
  actions :all, :except => [:create, :new, :edit, :update, :destroy]
  config.sort_order = "ID_asc"

  index do
    column :ID
    column :UrlName
    column :Name

    default_actions
  end
end
