import AVFoundation


            let asset = AVAsset(url: url)
            let durationSeconds = CMTimeGetSeconds(asset.duration)
            let generator = AVAssetImageGenerator(asset: asset)
            
            generator.appliesPreferredTrackTransform = true
            
            let time = CMTimeMakeWithSeconds(durationSeconds/3.0, preferredTimescale: 600)
            generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { (time, thumbnail, actualTime, result, error) in
                cell.pictureImg.image = nil
                OperationQueue.main.addOperation {
                   cell.pictureImg.image = UIImage(cgImage: thumbnail!)
                    
                }
            }

