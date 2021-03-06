class Canvas::Course < Canvas::Model
  attribute :sis_course_id, String
  attribute :name, String
  attribute :course_code, String
  attribute :workflow_state, String
  attribute :account_id, Integer
  attribute :start_at, Date
  attribute :end_at, Date
  attribute :offer, Boolean
  attribute :open_enrollment, Boolean
  attribute :self_enrollment, Boolean

  def students
    @students ||= Canvas::Enrollment.for_course(self).select &:student?
  end

  # Find the course by its course code. This only returns courses in which the API user is enrolled.
  # That is why all courses created through the Canvas Client add the API user as a teacher.
  def self.find_by_code(code)
    all.detect { |course| course['course_code'] == code }
  end

  def self.find_by_sis_id(sis_id)
    all.detect { |course| course['sis_course_id'] == sis_id }
  end

  def self.base_url
    'courses'
  end

  def create_url
    File.join 'accounts', client.account, 'courses'
  end

  def create_params
    params = {
      course: {
        sis_course_id: sis_course_id,
        name: name,
        course_code: course_code,
        enroll_me: true
      }
    }
    params.merge!(offer: offer) unless offer.nil?
    params.merge!(start_at: start_at) unless start_at.nil?
    params.merge!(end_at: end_at) unless end_at.nil?
    params
  end

  def update_params
    {
        course: {
            sis_course_id: sis_course_id,
            name: name,
            course_code: course_code,
            start_at: start_at,
            end_at: end_at,
            offer: offer
        }
    }
  end

  def destroy
    client.delete(resource_url + '?event=delete') and freeze
  end

  def conclude
    client.delete(resource_url + '?event=conclude') and freeze
  end

  def open
    self.self_enrollment = true
    self.open_enrollment = true
    self.offer = true
    save
  end

  def close
    self.self_enrollment = false
    self.open_enrollment = false
    self.offer = false
    save
  end

  def add_student(student)
    Canvas::Enrollment.add_student_to_course student_id: student.id, course_id: id
  end

  def add_teacher(teacher)
    Canvas::Enrollment.add_teacher_to_course teacher_id: teacher.id, course_id: id
  end

  def remove_student(student)
    enrollment = students.detect { |item| item.user_id == student.id }
    enrollment.destroy if enrollment
  end

end