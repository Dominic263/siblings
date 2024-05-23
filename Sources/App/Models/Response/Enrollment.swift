import Vapor

struct TeacherEnrollmentResponse: Content {
    let teacher: Teacher
    let subjectStudentResponse: SubjectStudentResponse
}

struct StudentEnrollmentResponse: Content {
    let student: Student
    let subjectsTeacherResponse: SubjectTeacherResponse
}

struct SubjectEnrollmentResponse: Content {
    let subject: Subject
    let studentsTeacherResponse: StudentTeacherResponse
}
