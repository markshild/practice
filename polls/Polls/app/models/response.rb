class Response < ActiveRecord::Base

  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_poller

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
    )

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  has_one :question, through: :answer_choice, source: :question

  def sibling_responses
    # question
    #   .responses
    #   .where("? is NULL OR responses.id != ?", self.id, self.id)


    responses_question_id = <<-SQL
      SELECT
        questions.id
      FROM
        questions
      JOIN
        answer_choices ON answer_choices.question_id = questions.id
      WHERE
        answer_choices.id = ?
      LIMIT
        1
    SQL


    Response
      .joins(:question)
      .where("answer_choices.question_id = (#{responses_question_id})", self.answer_choice_id)
      .where("? is NULL OR responses.id != ?", self.id, self.id)

    # SELECT
    #   sibling_responses.*
    # FROM
    #   questions
    # INNER JOIN
    #   answer_choices AS sibling_answer_choices
    #   ON sibling_answer_choices.question_id = questions.id
    # LEFT OUTER JOIN
    #   responses AS sibling_responses
    #   ON sibling_answer_choices.id = sibling_responses.answer_choice_id
    # WHERE
    #   sibling_answer_choices.question_id = (
    #         SELECT
    #           questions.id
    #         FROM
    #           questions
    #         JOIN
    #           answer_choices ON answer_choices.question_id = questions.id
    #         WHERE
    #           answer_choices.id = 2
    #         LIMIT
    #           1
    #   )
    #   AND (
    #     2 is NULL
    #     OR sibling_responses.id != 2 )

  end

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: self.user_id)
      errors[:user_id] << "has already responded"
    end
  end

  def respondent_is_not_poller

    # poll_author_id = answer_choice.question.poll.author_user_id  Who wants one extra query!!!

    poll_author_id = Poll
                      .joins(questions: {answer_choices: :responses} )
                      .where('answer_choices.id = ?', self.answer_choice_id)
                      .first
                      .author_user_id

    if poll_author_id == self.user_id
      errors[:user_id] << "can't respond to own poll"
    end
  end

end
