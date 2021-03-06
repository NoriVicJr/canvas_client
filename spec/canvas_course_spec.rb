require 'spec_helper'

describe Canvas::Course do

  it 'should load a course by ID' do
    VCR.use_cassette 'load_course' do
      course = Canvas::Course.find 1
      course.id.must_equal 1
    end
  end

  it 'should create a new course' do
    VCR.use_cassette 'create course' do
      course = Canvas::Course.new
      course.name = 'Intro to Basketweaving'
      course.sis_course_id = 2
      course.course_code = 'BASKET101'
      course.save
      course.id.wont_be_nil
    end
  end

  it 'should edit a course' do
    VCR.use_cassette 'edit course' do
      course = Canvas::Course.find 2
      course.name = 'Intermediate Basketweaving'
      course.save
      course.name.must_equal 'Intermediate Basketweaving'
    end
  end

  it 'should conclude a course' do
    VCR.use_cassette 'conclude course' do
      course = Canvas::Course.find 2
      course.conclude
      course.frozen?.must_equal true
    end
  end

  it 'should delete a course' do
    VCR.use_cassette 'delete course' do
      course = Canvas::Course.find 2
      course.destroy
      course.frozen?.must_equal true
    end
  end

  it 'should open a course for registration' do
    VCR.use_cassette 'opens course' do
      course = Canvas::Course.find 2
      course.open
    end
  end

  it 'should have students' do
    VCR.use_cassette 'course enrollments' do
      course = Canvas::Course.find 2
      course.students.wont_be_empty
    end
  end

  it 'should gracefully 404 a course that does not exist' do
    VCR.use_cassette('course does not exist') do
      course = Canvas::Course.find 42
      course.must_be_nil
    end
  end

  it 'should find the course by course code' do
    VCR.use_cassette('course found by code') do
      course = Canvas::Course.find_by_code 'Beginning'
      course.wont_be_nil
    end
  end

  it 'should find the course by sis id' do
    VCR.use_cassette('course found by sis id') do
      course = Canvas::Course.find_by_sis_id '1'
      course.wont_be_nil
    end
  end

  context '#enrollment' do

    before {
      VCR.use_cassette('load_course_and_student') do
        @course = Canvas::Course.find 2
        @student = Canvas::User.find 2
      end
    }

    it 'should add student to course' do
      VCR.use_cassette('course add student') do
        @course.add_student(@student)
      end
    end

    it 'should remove student from course' do
      VCR.use_cassette('course remove student') do
        @course.remove_student(@student)
      end
    end

    it 'should add teacher ot course' do
      VCR.use_cassette('add teacher to course') do
        @course.add_teacher @student
      end
    end

  end


end