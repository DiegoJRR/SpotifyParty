Original App Design Project - README Template
===

# PartyDJ / SpotifyParty / PartyQ (Party 'Queue')

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The idea of this app is to solve the problem of music playlists at parties (["Pass the aux cord"](https://knowyourmeme.com/memes/hand-me-the-aux-cord)), where only one person is connected to the speakers via their phone. This app would allow the other attendees to automatically add / propose songs to the music queue, which would be added to the current playlist. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Entertainment
- **Mobile:** Is uniquely mobile because that's the device most of the people carry with them at a party, and the most appropiate for the use case.
- **Story:** Allow users to create a group playlist / queue in real time for parties or social events in real 
- **Market:** Anyone who uses spotify at social events 
- **Habit:** The idea is that users will relly on this app when on social events, and invite others to use it and make the process easier for everyone.
- **Scope:** The most basic function would be to add songs automatically. It could be expanded with a rating system, and more control to the group and owner to organice the playlist.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

1) Authentication (Log in / Log out / Sign up)
2) Find local parties / events
3) Add new songs to the playing playlist in a nearby event
4) Scan QR to access the party's playlist
5) ...

**Optional Nice-to-have Stories**


* Directly sharing songs from Spotify
* Ranking and reordering of playlist
* Limited permissions 
* Banning of explicit songs
* Group volume control
* Follow / save party's playlist on user's account
* Push whole playlist to queue
* ...

### 2. Screen Archetypes

* Login Screen (Authentication)
   * Satisfies user story #1 

* Nearby Playlists (Stream / Map View)
   * Satisfies user story #1 and #4 

* Currently Playing (Stream)
   * Satisfies #3 and several optional user stories 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Find Playlists
* Currently Playing
* Settings

**Flow Navigation** (Screen to Screen)

* Find Playlists
   * TableView with the playlist being played nearby, host and other relevant information
   * Button to create a new group playlist
   * ...
* Currently Playing
   * See a stream view of the currently playing song
   * Upvote or downvote songs
   * Suggest a new volume
   * Vote to skip song
   * ...
* Settings
   * Configure default permissions for your playlists 
   * Set you profile information
   * Connect or disconnect your spotify account
   * ... 

## Wireframes
 [Wireframe](https://imgur.com/a/mGH7KhW) for the app 

<img src="https://i.imgur.com/5Ep57fs.png" width=''>

## Schema 

### Models
This section includes the data objects that will be used for the app

#### Event

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id | string | unique identifier |
   | name | string | name of the event |
   | description | string | description of the event |
   | hosts | Array of Users | user hosting the event in the app |
   | attendees | Array of Users | users connected to the event in the app |
   | playlist | Playlist | playlist for the event |
   | songsVotes | dictionary | dictionary with the votes for each song in the playlist of the event| 
   
### Playlist
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id | string | id to identify the playlist in spotify |
   | name | string | name of the playlist |
   | cover | File | image for the cover art |
   | description | string | description of the playlist |
   | owner / creator | User | user that created the playlist | 
   | collaborative | Bool | if the playlist is collaborative or not |
   | songs | Array of Songs objects | stores the songs currently in the playlist | 
   
### Song

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id | string | id to pull the song from spotify |
   | title | string | title of the song | 
   | artist | string | name of the artist |
   | length | int | length in seconds of the song |
   
   
### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id | string | unique id of the user in spotify | 
   | username | string | name to use inside the app | 
   | profileImage | file | image to use for profile picture |
   | ... | | |


### Networking
- https://developer.spotify.com/documentation/ios/


## Questions / Things to research
 - How to share data from the Spotify app to mine: https://medium.com/@dinesh.kachhot/different-ways-to-share-data-between-apps-de75a0a46d4a#:~:text=An%20object%20that%20helps%20a,share%20from%20%E2%80%94%20use%20named%20pasteboards.
 - 
