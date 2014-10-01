class NteeMajorGroup < ActiveRecord::Base
  set_table_name "NteeMajorGroups"

  has_many :ntee_common_codes, foreign_key: 'MajorGroupID'
end
