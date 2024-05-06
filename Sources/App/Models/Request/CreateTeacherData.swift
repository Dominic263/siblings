import Foundation
import Vapor

struct CreateTeacherData: Content {
    let firstName: String
    let lastName: String
}
