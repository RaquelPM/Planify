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
class Event < ApplicationRecord
  # @!attribute creator
  #   @return [User]
  belongs_to :creator, class_name: :User, foreign_key: :creator_id
  has_many :participations
  has_many :participants, through: :participations, source: :user

  validates :name, :start_date, :creator_id, presence: true
  validates :name, length: { minimum: 3, maximum: 150 }
  validates :description, length: { maximum: 2000 }, allow_blank: true
  validates :place, length: { minimum: 3, maximum: 150 }
  validates :finish_date, comparison: { greater_than: :start_date }, if: -> { !finish_date.nil? }

  scope :search_by_name, ->(name) { where('LOWER(name) LIKE ?', "%#{name.downcase}%") }
  scope :authorized, lambda { |current_user|
    joins(
      <<~CUSTOM_SQL
        LEFT JOIN participations current_user_participations
        ON current_user_participations.event_id = events.id
        AND current_user_participations.user_id = #{current_user.id || -1}
      CUSTOM_SQL
    )
      .where(
        <<~CUSTOM_SQL
          current_user_participations.user_id IS NOT NULL
          OR events.is_public
        CUSTOM_SQL
      )
  }
  
  private :participations, :participations=
end