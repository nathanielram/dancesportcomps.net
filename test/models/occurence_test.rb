# == Schema Information
#
# Table name: occurences
#
#  id             :integer          not null, primary key
#  start_date     :date
#  end_date       :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#

require 'test_helper'

class OccurenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
