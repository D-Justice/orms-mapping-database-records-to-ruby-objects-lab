class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    newInstance = self.new
    newInstance.id = row[0]
    newInstance.name = row[1]
    newInstance.grade = row[2]
    newInstance
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    newInstance = self.new
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
      

  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end
  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    
  end

  def self.first_X_students_in_grade_10(numOfStudents)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, numOfStudents).map do |row|
      self.new_from_db(row)
    end
  end
  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT 1"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first

  end
  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end
end
