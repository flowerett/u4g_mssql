ActiveAdmin.register User do
  config.filters = false
  scope :all
  actions :all, :except => [:create, :new, :edit, :update, :destroy]

  index do
    column :ID
    column :UID
    column :FirstName
    column :LastName
    column :Email
    default_actions
  end
end
