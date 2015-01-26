require 'singleton'
require 'sqlite3'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def self.execute(sql, *bindings)
    puts sql
    instance.execute(sql, *bindings)
  end

  def initialize
    super('questions.db')

    self.results_as_hash = true

    self.type_translation = true
  end
end

#save(q1,q1.instance_variables.map {|i| i.to_s})

def save(instance)
  class_name = instance.class.to_s
  table_name = ""
    case class_name
    when "User"
      table_name = 'users'
    when "Question"
      table_name ='questions'
    when "Reply"
      table_name = 'replies'
    when "QuestionLike"
      table_name = 'question_likes'
    when "QuestionFollower"
      table_name = 'question_followers'
    end



  result = QuestionsDatabase.execute(<<-SQL, instance.id)
    SELECT id
    FROM #{table_name}
    WHERE id = ?
  SQL

  column_names = instance.instance_variables.map {|el| el.to_s }
  tmp = column_names.shift

  column_names.map! {|el| el.split('')[1..-1].join }

  column_count = column_names.count
  q_marks = []
  column_count.times do
    q_marks << '?'
  end
  arguments = column_names.map {|el| "'#{instance.send(el)}'" }

  set_now = column_names.map.with_index{|el, ind|"#{el} = #{arguments[ind]}"}.join(', ')

  argu = arguments.join(', ')


  if result.empty?
    QuestionsDatabase.execute(<<-SQL)
      INSERT INTO #{table_name} (#{column_names.join(', ')})
      VALUES (#{argu })
    SQL
    instance.id = QuestionsDatabase.instance.last_insert_row_id
  else
    QuestionsDatabase.execute(<<-SQL, instance.id)
      UPDATE #{table_name}
      SET #{set_now}
      WHERE id = ?
    SQL
  end
  nil
end


class User
  attr_accessor :id, :fname, :lname
  def initialize(options = {})
    @id, @fname, @lname =
      options.values_at('id', 'fname', 'lname')
  end

  def self.find_by_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM users
      WHERE id = ?
      SQL
    User.new(results.first)
  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
      SQL
    User.new(results.first)
  end

  def authored_questions
    results = Question.find_by_author_id(self.id)
    results.map {|result| Question.new(result)}
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_question_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        (SUM(t1.likes) / CAST( COUNT(t1.questions) AS FLOAT)) AS value
      FROM (
        SELECT q.id as questions, COUNT(DISTINCT(ql.question_id)) AS likes
        FROM questions as q
        LEFT OUTER JOIN question_likes as ql
          ON q.id = ql.question_id
        WHERE q.user_id = ? AND ql.question_id IS NOT NULL) AS t1
      SQL

    result.first['value']
  end

  def save
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT id
      FROM users
      WHERE id = ?
    SQL
    if result.empty?
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO users (fname, lname)
        VALUES (?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE users
        SET fname = ?, lname = ?
        WHERE id = ?
      SQL
    end
    nil
  end

end

class Question
  attr_accessor :id, :user_id, :title, :body
  def initialize(options = {})
    @id, @title, @body, @user_id =
      options.values_at('id', 'title', 'body', 'user_id')
  end

  def self.find_by_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM questions
      WHERE id = ?
      SQL
    Question.new(results.first)
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT *
      FROM questions
      WHERE user_id = ?
      SQL
    results.map {|result| Question.new(result)}
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def author
    result = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT *
      FROM users
      WHERE id = ?
      SQL
    User.new(result.first)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def save
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT id
      FROM questions
      WHERE id = ?
    SQL
    if result.empty?
      QuestionsDatabase.instance.execute(<<-SQL, @user_id, @title, @body)
        INSERT INTO questions (user_id, title, body)
        VALUES (?, ?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @user_id, @title, @body, @id)
        UPDATE questions
        SET user_id = ?, title = ?, body = ?
        WHERE id = ?
      SQL
    end
    nil
  end

end

class Reply
  attr_accessor :id, :user_id, :body, :question_id, :parent_reply_id
  def initialize(options = {})
    @id, @body, @question_id, @user_id, @parent_reply_id =
      options.values_at('id', 'body', 'question_id', 'user_id', 'parent_reply_id')
  end

  def self.find_by_id(reply_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
      SELECT *
      FROM replies
      WHERE id = ?
      SQL
    Reply.new(results.first)
  end

  def self.find_by_question_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM replies
      WHERE question_id = ?
      SQL
    results.map {|result| Reply.new(result)}
  end

  def self.find_by_user_id(u_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT *
      FROM replies
      WHERE user_id = ?
      SQL
    results.map {|result| Reply.new(result)}
  end

  def author
    result = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT *
      FROM users
      WHERE id = ?
      SQL
    User.new(result.first)
  end

  def question
    result = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT *
      FROM questions
      WHERE id = ?
      SQL
    Question.new(result.first)
  end

  def parent_reply
    result = QuestionsDatabase.instance.execute(<<-SQL, @parent_reply_id)
      SELECT *
      FROM replies
      WHERE id = ?
      SQL
    raise "no parent reply" if result.empty?
    Reply.new(result.first)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT *
      FROM replies
      WHERE parent_reply_id = ?
      SQL
    results.map {|result| Reply.new(result)}
  end

  def save
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT id
      FROM replies
      WHERE id = ?
    SQL

    if result.empty?
      QuestionsDatabase.instance.execute(<<-SQL, @body, @question_id, @user_id, @parent_reply_id)
        INSERT INTO replies (body, question_id, user_id, parent_reply_id)
        VALUES (?, ?, ?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @body, @question_id, @user_id, @parent_reply_id, @id)
        UPDATE replies
        SET body = ?, question_id = ?, user_id = ?, parent_reply_id = ?
        WHERE id = ?
      SQL
    end
    nil
  end


end

class QuestionLike
  attr_accessor :id, :user_id, :question_id,
  def initialize(options = {})
    @id, @question_id, @user_id =
      options.values_at('id', 'question_id', 'user_id')
  end

  def self.find_by_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM question_likes
      WHERE id = ?
      SQL
    QuestionLike.new(results.first)
  end

  def self.likers_for_question_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT users.*
      FROM users
      JOIN question_likes AS ql
        ON ql.user_id = users.id
      WHERE ql.question_id = ?
      SQL
    results.map {|result| User.new(result) }
  end

  def self.num_likes_for_question_id(q_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT COUNT(*) AS count
      FROM question_likes
      WHERE question_id = ?

      SQL
    result.first['count']
  end

  def self.liked_questions_for_user_id(u_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT questions.*
      FROM questions
      JOIN question_likes AS ql
        ON ql.question_id = questions.id
      WHERE ql.user_id = ?
      SQL
    results.map {|result| Question.new(result) }
  end

  def self.most_liked_questions(n) # need to test
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT questions.* LIMIT ?
      FROM questions
      JOIN question_likes AS ql
        ON ql.question_id = questions.id
      GROUP BY questions.id
      ORDER BY COUNT(qf.user_id) DESC
      SQL
    results.map {|result| Question.new(result) }

  end

  def save
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT id
      FROM question_likes
      WHERE id = ?
    SQL
    if result.empty?
      QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id)
        INSERT INTO question_likes (user_id, question_id)
        VALUES (?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id, @id)
        UPDATE question_likes
        SET user_id = ?, question_id = ?
        WHERE id = ?
      SQL
    end
    nil
  end


end

class QuestionFollower
  attr_accessor :id, :user_id, :question_id
  def initialize(options = {})
    @id, @user_id, @question_id =
      options.values_at('id', 'user_id', 'question_id')
  end

  def self.find_by_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM question_followers
      WHERE id = ?
      SQL
    QuestionFollower.new(results.first)
  end

  def self.followers_for_question_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT users.*
      FROM users
      JOIN question_followers
        ON questions_followers.user_id = users.id
      WHERE question_id = ?
      SQL
    results.map {|result| User.new(result) }
  end

  def self.followed_question_for_user_id(u_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT questions.*
      FROM questions
      JOIN question_followers
        ON questions_followers.question_id = questions.id
      WHERE user_id = ?
      SQL
    results.map {|result| Question.new(result) }
  end

  def self.most_followed_questions(n) # need to test
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT questions.* LIMIT ?
      FROM questions
      JOIN question_followers AS qf
        ON qf.question_id = questions.id
      GROUP BY questions.id
      ORDER BY COUNT(qf.user_id) DESC
      SQL
    results.map {|result| Question.new(result) }

  end

  def save
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT id
      FROM question_followers
      WHERE id = ?
    SQL
    if result.empty?
      QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id)
        INSERT INTO question_followers (user_id, question_id)
        VALUES (?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id, @id)
        UPDATE question_followers
        SET user_id = ?, question_id = ?
        WHERE id = ?
      SQL
    end
    nil
  end

end
