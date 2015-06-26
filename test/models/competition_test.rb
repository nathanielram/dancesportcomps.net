# == Schema Information
#
# Table name: competitions
#
#  id               :integer          not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comp_association :string
#  website          :string
#  slug             :string
#  country          :string
#

require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
