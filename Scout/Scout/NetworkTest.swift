//
//  NetworkTest.swift
//  Scout
//
//  Created by Anna on 2/24/26.
//

import Supabase
import Foundation


//struct Profile: Decodable {
//  let id: String
//  let displayName: String
//
//  private enum CodingKeys: String, CodingKey {
//    case id
//    case displayName = "display_name"
//  }
//}
//
//@MainActor
//func testSignup(email: String, password: String) async throws {
//  _ = try await supabase.auth.signUp(email: email, password: password)
//}
//
//@MainActor
//func testSignin(email: String, password: String) async throws {
//  _ = try await supabase.auth.signIn(email: email, password: password)
//}
//
//@MainActor
//func fetchMyProfile() async throws -> Profile {
//  guard let user = supabase.auth.currentUser else {
//    throw NSError(domain: "NoUser", code: 1)
//  }
//
//  let response: Profile = try await supabase
//    .from("profiles")
//    .select("id, display_name")
//    .eq("id", value: user.id)
//    .single()
//    .execute()
//    .value
//
//  return response
//}
//
//@MainActor
//func updateDisplayName(_ newName: String) async throws {
//  guard let user = supabase.auth.currentUser else {
//    throw NSError(domain: "NoUser", code: 2)
//  }
//
//  _ = try await supabase
//    .from("profiles")
//    .update(["display_name": newName])
//    .eq("id", value: user.id)
//    .execute()
//}
