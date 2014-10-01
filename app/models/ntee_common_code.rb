class NteeCommonCode < ActiveRecord::Base
  set_table_name "NteeCommonCodes"

  belongs_to :ntee_major_group, foreign_key: 'MajorGroupID'
end
