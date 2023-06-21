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
class EventSerializer < ApplicationSerializer
  attributes :id, :name, :description, :is_public
  detailed_attributes :place, :start_date, :finish_date
  belongs_to :creator, key: :user, presentation: :detailed, if: :detailed?
end
