//
//  ExerciseUploader.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/10/26.
//

import Foundation
import FirebaseFirestore

class ExerciseUploader {
    
    private let db = Firestore.firestore()
    private let pexelsAPIKey = "b4vYetjCULRDs4ql41qIm0BNaBNaPQbI521PDUYlOghOfnvWqhBalSZr"

    func uploadAllExercises() {
        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let exercises = try? JSONDecoder().decode([ExerciseData].self, from: data) else {
            print("Failed to load json")
            return
        }
        
        print("\(exercises.count) exercises")
        
        Task {
            var newExercises: [ExerciseData] = []
            
            for exercise in exercises {
                do {
                    let snapshot = try await db.collection("exercises").document(exercise.id).getDocument()
                    
                    if !snapshot.exists {
                        newExercises.append(exercise)
                        print("New: \(exercise.name)")
                    } else {
                        print("Skipping: \(exercise.name) (already exists)")
                    }
                } catch {
                    print("Error checking \(exercise.name): \(error)")
                }
            }
            
            print("\n Uploading \(newExercises.count) new exercises...")
            
            if newExercises.isEmpty {
                print("All exercises already exist!")
                return
            }
            
            for (index, exercise) in newExercises.enumerated() {
                if index > 0 {
                    try? await Task.sleep(nanoseconds: 20_000_000_000)
                }
                await uploadExerciseWithMedia(exercise)
            }
        }
    }

    private func uploadExerciseWithMedia(_ exercise: ExerciseData) async {
        print("Processing: \(exercise.name)")
        
        let (imageUrl, videoUrl) = await fetchPexelsMedia(query: exercise.searchQuery)
        
        let exerciseDoc: [String: Any] = [
            "name": exercise.name,
            "muscleGroup": exercise.muscleGroup,
            "equipment": exercise.equipment,
            "difficulty": exercise.difficulty,
            "instructions": exercise.instructions,
            "imageUrl": imageUrl ?? "",
            "videoUrl": videoUrl ?? "",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        do {
            try await db.collection("exercises").document(exercise.id).setData(exerciseDoc)
            print("Uploaded: \(exercise.name)")
        } catch {
            print("Failed: \(exercise.name) - \(error.localizedDescription)")
        }
    }

    private func fetchPexelsMedia(query: String) async -> (String?, String?) {
        async let imageUrl = fetchPexelsImage(query: query)
        async let videoUrl = fetchPexelsVideo(query: query)
        return await (imageUrl, videoUrl)
    }

    private func fetchPexelsImage(query: String) async -> String? {
        let urlString = "https://api.pexels.com/v1/search?query=\(query)&per_page=1"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue(pexelsAPIKey, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let photos = json["photos"] as? [[String: Any]],
               let firstPhoto = photos.first,
               let src = firstPhoto["src"] as? [String: Any],
               let imageUrl = src["tiny"] as? String {
                return imageUrl
            }
        } catch {
            print("Image fetch error: \(error)")
        }
        
        return nil
    }

    private func fetchPexelsVideo(query: String) async -> String? {
        let urlString = "https://api.pexels.com/videos/search?query=\(query)&per_page=1"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid URL")
            return nil
        }
            
        var request = URLRequest(url: url)
        request.setValue(pexelsAPIKey, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 429 {
                    print("RATE LIMITED")
                    return nil
                }
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Failed to parse JSON")
                return nil
            }
            
            print("🎥 JSON parsed successfully")
            
            guard let videos = json["videos"] as? [[String: Any]] else {
                print("No videos in response")
                print("Available keys: \(json.keys)")
                return nil
            }
            
            print("Found \(videos.count) videos")
            
            guard let firstVideo = videos.first else {
                print("Videos array is empty")
                return nil
            }
            
            print("First video: \(firstVideo.keys)")
            
            guard let videoFiles = firstVideo["video_files"] as? [[String: Any]] else {
                print("No video_files in first video")
                return nil
            }
            
            print("Found \(videoFiles.count) video files")
            
            let qualities = videoFiles.compactMap { $0["quality"] as? String }
            print("Available qualities: \(qualities)")
            
            if let hdFile = videoFiles.first(where: { ($0["quality"] as? String) == "hd" }),
               let videoUrl = hdFile["link"] as? String {
                print("Found HD video: \(videoUrl)")
                return videoUrl
            }
            
            if let anyFile = videoFiles.first,
               let videoUrl = anyFile["link"] as? String {
                print("Found video (non-HD): \(videoUrl)")
                return videoUrl
            }
            
            print("No video link found in files")
            return nil
            
        } catch {
            print("Network error: \(error.localizedDescription)")
            return nil
        }
    }
}
