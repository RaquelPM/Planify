# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  description :text
#  finish_date :datetime
#  is_public   :boolean          default(FALSE)
#  name        :string           not null
#  place       :string           not null
#  start_date  :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :integer          not null
#
# Indexes
#
#  index_events_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  creator_id  (creator_id => users.id)
#
require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
