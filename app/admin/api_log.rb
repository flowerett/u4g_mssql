ActiveAdmin.register ApiLog do
  config.filters = false
  scope :all
  actions :all, :except => [:create, :new, :edit, :update, :destroy]
end
