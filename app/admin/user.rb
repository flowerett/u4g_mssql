ActiveAdmin.register User do
  config.filters = false
  scope :all, default: true
  actions :all, :except => [:create, :new, :edit, :update, :destroy]
  config.sort_order = "ID_asc"

  index do
    column :ID
    column :UID
    column :FirstName
    column :LastName
    column :Email
    default_actions
  end
end
