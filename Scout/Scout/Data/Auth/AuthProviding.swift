//
//  AuthProviding.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

protocol AuthProviding {
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut() async throws
}
