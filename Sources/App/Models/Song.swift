//
//  Song.swift
//
//  Created by Daniel O'Leary on 2/2/22.
//

import Fluent
import Vapor

final class Song: Model, Content {

	static let schema = "songs"

	// @ID(key:) tells Fluent that the key matches the propety in the class.
	@ID(key: .id)
	var id: UUID?

	@Field(key: "title")
	var title: String

	init() { }

	init(id: UUID? = nil, title: String) {
		self.id = id
		self.title = title
	}

}
