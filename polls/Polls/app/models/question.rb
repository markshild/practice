class Question < ActiveRecord::Base

validates :poll_id, :text, presence: true

  belongs_to(
    :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id
    )

  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id,
    dependent: :destroy
    )

  has_many :responses, through: :answer_choices, source: :responses

  def bad_results
    results = {}
    answers = answer_choices
    answers.each do |answer|
      results[answer.text] = answer.responses.length
    end

    results
  end

  def mediocre_results
    results = {}
    answers = answer_choices.includes(:responses)
    answers.each do |answer|
      results[answer.text] = answer.responses.length
    end

    results
  end

  def results
    results = {}
    answers = answer_choices
      .select('answer_choices.*, COUNT(responses.id) AS response_count')
      .joins('LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id')
      .group(:'answer_choices.id')

    answers.each do |answer|
      results[answer.text] = answer.response_count
    end
  # =begin
  # Question.find_by_sql([<<-SQL, 1])
  # SELECT
  #   answer_choices.*, COUNT(responses.id) AS response_count
  # FROM
  #   answer_choices
  # LEFT OUTER JOIN
  #   responses ON responses.answer_choice_id = answer_choices.id
  # WHERE
  #   answer_choices.question_id = ?
  # GROUP BY
  #   answer_choices.id
  #   SQL
  # =end
  #

    results
  end

end
