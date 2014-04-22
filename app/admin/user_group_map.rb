ActiveAdmin.register UserGroupMap do
  config.filters = false
  scope :all, default: true
  actions :all, :except => [:create, :new, :edit, :update, :destroy]
end
