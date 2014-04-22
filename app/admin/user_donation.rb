ActiveAdmin.register UserDonation do
  config.filters = false
  scope :all, default: true
  actions :all, :except => [:create, :new, :edit, :update, :destroy]
  config.sort_order = "ID_asc"
end
