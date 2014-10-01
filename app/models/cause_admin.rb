class CauseAdmin < ActiveRecord::Base
  set_table_name "CauseAdmins"

  belongs_to :user, foreign_key: 'UserAdminID'
  belongs_to :cause, foreign_key: 'CauseID'
end
