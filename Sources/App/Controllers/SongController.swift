//
//  SongController.swift
//
//  Created by Daniel O'Leary on 2/2/22.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
	// boot(route:) is like an init() func.
	// it is the first function that runs.
	func boot(routes: RoutesBuilder) throws {
		let songs = routes.grouped("songs")
		songs.get(use: index)
		songs.post(use: create)
		songs.put(use: update)
		songs.group(":songID") { song in
			song.delete(use: delete)
		}
	}

	// GET Request /songs route
	func index(req: Request) throws -> EventLoopFuture<[Song]> {
		return Song.query(on: req.db).all()
	}

	// POST Request /songs route
	func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
		let song = try req.content.decode(Song.self)
		return song.save(on: req.db).transform(to: .ok)
	}

	// PUT Request /songs routes
	func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
		// Find the song we want to update
		let song = try req.content.decode(Song.self)


		return Song.find(song.id, on: req.db)
			.unwrap(or: Abort(.notFound))
			// if the song was found, update the song title
			.flatMap { foundSong in
				foundSong.title = song.title
				return foundSong.update(on: req.db).transform(to: .ok)
			}
	}

	// DELETE Request /songs/id routes
	func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
		// Fluent is what is doing the `.find()` on Song
		Song.find(req.parameters.get("songID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { $0.delete(on: req.db) }.transform(to: .ok)
	}


}
