ActiveAdmin.register Cause do
  config.filters = false
  scope :all
  actions :all, :except => [:create, :new, :edit, :update, :destroy]

  index do
    column :ID
    column :UrlName
    column :Name

    default_actions
  end
end
