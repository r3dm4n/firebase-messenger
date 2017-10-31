//
//  Constants.swift
//  firebase-messenger
//
//  Created by r3d on 24/10/2017.
//  Copyright © 2017 Alexandru Corut. All rights reserved.
//

import Foundation
import Firebase

//Firebase
let CURRENT_USER = Auth.auth().currentUser
let BASE_REF = Database.database().reference()

//Firebase DB
let USERS = "users"
let USER_MESSAGES = "user-messages"
let NAME = "name"
let EMAIL = "email"
let PROFILE_IMG_URL = "profileImageUrl"
let MESSAGES = "messages"
let TEXT = "text"
let FROM_ID = "fromId"
let TO_ID = "toId"
let TIMESTAMP = "timestamp"

//Firebase Storage
let PROFILE_IMAGES = "profile_images"

//Strings
let SEND = "Send"
let ENTER_MESSAGE = "Enter message"
let NEW_MESSAGE = "New Message"
let APP_TITLE = "Firebase Messenger"
let LOGIN = "Login"
let LOGOUT = "Logout"
let CANCEL = "Cancel"
let REGISTER = "Register"
let PLACEHOLDER_NAME = "Name"
let PLACEHOLDER_EMAIL = "Email"
let PLACEHOLDER_PASSWORD = "Password"

//Cell id
let NEW_MESSAGE_CELL_ID = "cellId"

let IMAGE_PICKER_EDITED_IMAGE = "UIImagePickerControllerEditedImage"
let IMAGE_PICKER_ORIGINAL_IMAGE = "UIImagePickerControllerOriginalImage"

//MESSAGE COLORS
let BLUE_MESSAGE_COLOR = UIColor(r: 0, g: 137, b: 249)
let GRAY_MESSAGE_COLOR = UIColor(r: 240, g: 240, b: 240)


