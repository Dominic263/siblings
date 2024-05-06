import Foundation
import Vapor

struct CreateStudentData: Content {
    let firstName: String
    let lastName: String
}
