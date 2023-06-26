# == Schema Information
#
# Table name: participations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_participations_on_event_id  (event_id)
#  index_participations_on_user_id   (user_id)
#  unique_participant_per_event      ("user", "event") UNIQUE
#
# Foreign Keys
#
#  event_id  (event_id => events.id)
#  user_id   (user_id => users.id)
#
class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user, uniqueness: { scope: :event_id, message: 'has already joined the event' }
end
