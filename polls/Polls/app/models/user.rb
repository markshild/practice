class User < ActiveRecord::Base

validates :user_name, presence: true

  has_many(
    :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_user_id,
    primary_key: :id,
    dependent: :destroy
    )

  has_many(
    :responses,
    class_name: 'Response',
    foreign_key: :user_id,
    primary_key: :id,
    dependent: :destroy
    )

  def completed_polls

    sub_query = Response.where(user_id: self.id).to_sql


    Poll
    .joins(:questions => :answer_choices)
    .joins("LEFT OUTER JOIN (#{sub_query}) AS user_responses ON user_responses.answer_choice_id = answer_choices.id")
    .group('polls.id')
    .having('COUNT(DISTINCT questions.id) = COUNT(user_responses.id)')


    # SELECT
    #   polls.*
    # FROM
    #   questions
    # INNER JOIN
    #   polls ON polls.id = questions.poll_id
    # INNER JOIN
    #   answer_choices ON answer_choices.question_id = questions.id
    # LEFT OUTER JOIN
    #   (SELECT
    #      *
    #    FROM
    #      responses
    #    WHERE
    #      responses.user_id = ? ) AS user_responses
    #   ON user_responses.answer_choice_id = answer_choices.id
    #
    # GROUP BY
    #   polls.id
    # HAVING
    #   COUNT(DISTINCT questions.id) = COUNT(user_responses.id)

  end

  def incomplete_polls
    sub_query = Response.where(user_id: self.id).to_sql

    Poll
    .joins(:questions => :answer_choices)
    .joins("LEFT OUTER JOIN (#{sub_query}) AS user_responses ON user_responses.answer_choice_id = answer_choices.id")
    .group('polls.id')
    .having('COUNT(DISTINCT questions.id) != COUNT(user_responses.id) AND COUNT(user_responses.id) > 0')
  end
end
